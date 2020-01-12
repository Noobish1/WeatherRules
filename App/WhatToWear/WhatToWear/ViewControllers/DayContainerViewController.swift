import NotificationCenter
import RxSwift
import UIKit
import WhatToWearCore
import WhatToWearCoreComponents
import WhatToWearCoreUI
import WhatToWearModels
import WhatToWearNetworking

internal final class DayContainerViewController: CodeBackedViewController, StatefulContainerViewController, ForecastFetcherViewControllerProtocol, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = DayContainerViewController

        case mainView = "mainView"
    }

    // MARK: state
    internal enum State: ContainerViewControllerStateProtocol {
        case preLoading(PreloadingViewController)
        case loading(LoadingViewController<DayViewController>)
        case loaded(DayViewController)
        case errored(ErrorViewController)
        case end(EndViewController)

        internal var viewController: UIViewController {
            switch self {
                case .preLoading(let vc): return vc
                case .loading(let vc): return vc
                case .loaded(let vc): return vc
                case .errored(let vc): return vc
                case .end(let vc): return vc
            }
        }
    }

    // MARK: initParams
    internal enum InitParams {
        case needsLoading(date: Date, location: ValidLocation, load: Bool)
        case preloaded(date: Date, location: ValidLocation, forecast: TimedForecast)
        case end(date: Date, side: EndViewController.Side, onButtonTap: () -> Void)

        // MARK: computed properties
        internal var date: Date {
            switch self {
                case .needsLoading(date: let date, _, _):
                    return date
                case .preloaded(date: let date, _, _):
                    return date
                case .end(date: let date, _, _):
                    return date
            }
        }

        internal var loadInitially: Bool {
            switch self {
                case .needsLoading(_, _, load: let load):
                    return load
                case .preloaded, .end:
                    return false
            }
        }
    }

    // MARK: properties
    internal var containerView: UIView {
        return view
    }
    internal var state: State
    internal let date: Date
    internal let darkSkyClient = DarkSkyClient()
    internal let appLookupClient = AppLookupClient()
    internal let forecastController = ForecastController()
    internal var fetcherDisposeBag = DisposeBag()

    private let initialFetch = Singular()
    private let initParams: InitParams
    private let onLabelDoubleTap: () -> Void

    // MARK: computed properties
    internal var isEnd: Bool {
        switch state {
            case .end:
                return true
            case .errored, .loaded, .loading, .preLoading:
                return false
        }
    }

    // MARK: init/deinit
    internal init(params: InitParams, onLabelDoubleTap: @escaping () -> Void) {
        self.initParams = params
        self.onLabelDoubleTap = onLabelDoubleTap
        self.date = params.date

        switch params {
            case .needsLoading(_, _, load: let load):
                if load {
                    self.state = .loading(LoadingViewController())
                } else {
                    self.state = .preLoading(PreloadingViewController())
                }
            case .preloaded(date: let date, location: let location, forecast: let timedForecast):
                let dayVC = DayViewController(
                    day: date,
                    timedForecast: timedForecast,
                    location: location,
                    onLabelDoubleTap: onLabelDoubleTap
                )

                self.state = .loaded(dayVC)
            case .end(date: _, side: let side, onButtonTap: let onButtonTap):
                self.state = .end(EndViewController(side: side, context: .mainApp, onButtonTap: onButtonTap))
        }

        super.init()
    }

    // MARK: UIViewController
    internal override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        fixContainerTopConstraintOniOS10()
    }

    internal override func viewDidLoad() {
        super.viewDidLoad()

        view.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.mainView)

        setupInitialViewController(state.viewController, containerView: containerView)
    }

    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        initialFetch.performOnce {
            if initParams.loadInitially {
                fetchIfNeeded(force: true)
            }
        }
    }

    // MARK: transition
    internal func transitionToLoadingState(with date: Date) {
        transition(to: .loading(LoadingViewController()))
    }

    internal func transitionToErrorState(
        with date: Date,
        location: ValidLocation,
        onComplete: ((NCUpdateResult) -> Void)?
    ) {
        transition(to: .errored(ErrorViewController(
            loadedViewControllerType: DayViewController.self,
            onTap: { [weak self] in
                self?.fetchIfNeeded()
            },
            onLoadComplete: onComplete
        )))
    }

    internal func transitionToLoadedState(
        with timedForecast: TimedForecast,
        date: Date,
        location: ValidLocation,
        onComplete: ((NCUpdateResult) -> Void)?
    ) {
        let dayVC = DayViewController(
            day: date,
            timedForecast: timedForecast,
            location: location,
            onLabelDoubleTap: onLabelDoubleTap
        )

        transition(to: .loaded(dayVC))

        // We call this here because we don't really want to bother calling it all the way down as this is really only relevant to extension VCs
        onComplete?(.newData)
    }

    // MARK: fetch
    internal func fetchIfNeeded(force: Bool = false) {
        switch initParams {
            case .preloaded, .end: break
            case .needsLoading(date: let date, location: let location, load: _):
                if force {
                    fetchForecastWithCacheCheck(for: date, location: location)
                } else {
                    switch state {
                        case .errored, .preLoading:
                            fetchForecastWithCacheCheck(for: date, location: location)
                        case .loading, .loaded, .end:
                            break
                    }
                }
        }
    }

    // MARK: fixes
    private func fixContainerTopConstraintOniOS10() {
        // To reproduce the bug:
        // Step 1: start in portrait on an iOS 10 device
        // Step 2: rotate to landscape
        // Step 3: rotate back to portrait and notice the date label will overlap the status bar
        if ProcessInfo.processInfo.operatingSystemVersion.majorVersion == 10 {
            containerView.snp.remakeConstraints { make in
                if self.view.frame.height > self.view.frame.width {
                    if self.topLayoutGuide.length == 0 {
                        make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(30)
                    } else {
                        make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(10)
                    }
                } else {
                    make.top.equalToSuperview().offset(10)
                }

                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        }
    }
}
