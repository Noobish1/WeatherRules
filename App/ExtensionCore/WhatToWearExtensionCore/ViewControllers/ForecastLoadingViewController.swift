import ErrorRecorder
import Foundation
import NotificationCenter
import RxSwift
import WhatToWearCore
import WhatToWearCoreComponents
import WhatToWearCoreUI
import WhatToWearModels
import WhatToWearNetworking

public final class ForecastLoadingViewController<InnerViewController: ForecastBasedViewControllerProtocol>: CodeBackedViewController,
StatefulContainerViewController, ForecastFetcherViewControllerProtocol, ForecastBasedViewControllerProtocol {
    // MARK: state
    public typealias State = LoadingContainerState<InnerViewController>
    
    // MARK: properties
    private let initialParams: LoadingContainerParams
    private let makeInnerViewController: (ForecastLoadingParams) -> InnerViewController
    private let initialLoad = Singular()
    private let location: ValidLocation
    
    // fetcher properties
    public let forecastController = ForecastController()
    public let darkSkyClient = DarkSkyClient()
    public let appLookupClient = AppLookupClient()
    public var fetcherDisposeBag = DisposeBag()
    
    // container properties
    public var state: State
    public var containerView: UIView {
        return view
    }
    
    // MARK: init
    public init(
        params: LoadingContainerParams,
        makeInnerViewController: @escaping (ForecastLoadingParams) -> InnerViewController
    ) {
        let settings = GlobalSettingsController.shared.retrieve()
        
        if let forecast = forecastController.cachedForecast(for: params.date, location: params.location) {
            let vc = makeInnerViewController(.init(
                loadingContainerParams: params,
                timedForecast: forecast,
                settings: settings
            ))
            self.state = .loaded(vc, forecast: forecast, settings: settings)
        } else {
            self.state = .loading(LoadingViewController(title: ""))
        }
        
        self.initialParams = params
        self.location = params.location
        self.makeInnerViewController = makeInnerViewController
        
        super.init()
    }
    
    // MARK: setup
    private func setupViews() {
        setupInitialViewController(state.viewController, containerView: containerView)
    }
    
    // MARK: UIViewController
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Analytics.record(screen: .forecastLoading(initialParams.extensionType.analyticsScreen))
        
        performInitialLoadIfNeeded(for: initialParams.date)
    }
    
    // MARK: initial load
    private func performInitialLoadIfNeeded(for date: Date) {
        if state.needsInitialLoad {
            initialLoad.performOnce {
                fetchForecastWithCacheCheck(for: date, location: location)
            }
        }
    }
    
    // MARK: creating loaded viewcontrollers
    private func createLoadedViewController(
        date: Date,
        timedForecast: TimedForecast,
        settings: GlobalSettings,
        onLoadComplete: ((NCUpdateResult) -> Void)?
    ) -> InnerViewController {
        return makeInnerViewController(.init(
            loadingContainerParams: initialParams,
            timedForecast: timedForecast,
            settings: settings
        ))
    }
    
    // MARK: handling unchanged forecasts
    public func handleUnchangedForecast(_ timedForecast: TimedForecast, onComplete: ((NCUpdateResult) -> Void)?) {
        switch state {
            case .errored: break
            case .loading: break
            case .loaded(let vc, _, _):
                vc.handleUnchangedForecast(timedForecast, onComplete: onComplete)
        }
    }
    
    // MARK: transition
    public func transitionToLoadedState(
        with timedForecast: TimedForecast,
        date: Date,
        location: ValidLocation,
        onComplete: ((NCUpdateResult) -> Void)?
    ) {
        let newSettings = GlobalSettingsController.shared.retrieve()

        if
            case .loaded(let oldVC, forecast: let oldForecast, settings: let oldSettings) = state,
            newSettings == oldSettings && oldForecast == timedForecast
        {
            oldVC.handleUnchangedForecast(timedForecast, onComplete: onComplete)
        } else {
            let vc = createLoadedViewController(
                date: date,
                timedForecast: timedForecast,
                settings: newSettings,
                onLoadComplete: onComplete
            )

            transition(to: .loaded(vc, forecast: timedForecast, settings: newSettings))
        }
    }

    public func transitionToLoadingState(with date: Date) {
        if case .loading = state {
            return
        } else {
            transition(to: .loading(LoadingViewController<InnerViewController>()))
        }
    }

    public func transitionToErrorState(
        with date: Date,
        location: ValidLocation,
        onComplete: ((NCUpdateResult) -> Void)?
    ) {
        if case .errored = state {
            onComplete?(.failed)

            return
        } else {
            transition(to: .errored(ErrorViewController(
                loadedViewControllerType: InnerViewController.self,
                onTap: { [weak self] in
                    self?.fetchForecastWithCacheCheck(for: .now, location: location)
                }, onLoadComplete: onComplete
            )))
        }
    }
}

// MARK: ExtensionViewControllerProtocol
extension ForecastLoadingViewController: ExtensionViewControllerProtocol {
    public func preferredContentSize(for activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) -> CGSize {
        switch state {
            case .errored, .loading:
                return CGSize(
                    width: maxSize.width,
                    height: self.initialParams.extensionType.expandedHeight(
                        forWidth: maxSize.width, innerCalculatedHeight: .noneCalculated
                    )
                )
            case .loaded(let vc, forecast: _, settings: _):
                return vc.preferredContentSize(for: activeDisplayMode, withMaximumSize: maxSize)
        }
    }
    
    public func performUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        fetchForecastWithCacheCheck(for: .now, location: location, onComplete: completionHandler)
    }
}
