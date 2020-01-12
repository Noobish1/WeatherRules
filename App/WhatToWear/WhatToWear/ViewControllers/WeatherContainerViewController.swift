import NotificationCenter
import RxCocoa
import RxSwift
import Then
import UIKit
import WhatToWearCore
import WhatToWearCoreComponents
import WhatToWearCoreUI
import WhatToWearModels
import WhatToWearNetworking

internal final class WeatherContainerViewController: CodeBackedViewController, StatefulContainerViewController, ForecastFetcherViewControllerProtocol, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = WeatherContainerViewController

        case mainView = "mainView"
    }

    // MARK: states
    internal enum LoadedState: Equatable {
        case loading(LoadingViewController<WeatherPagingViewController>, date: Date)
        case loaded(WeatherPagingViewController, date: Date)
        case errored(ErrorViewController, date: Date)

        // MARK: computed properties
        internal var date: Date {
            switch self {
                case .loading(_, date: let date): return date
                case .loaded(_, date: let date): return date
                case .errored(_, date: let date): return date
            }
        }

        internal var needsInitialLoad: Bool {
            switch self {
                case .loading, .errored: return true
                case .loaded: return false
            }
        }

        internal var viewController: UIViewController {
            switch self {
                case .loading(let vc, date: _): return vc
                case .loaded(let vc, date: _): return vc
                case .errored(let vc, date: _): return vc
            }
        }
    }

    internal enum State: ContainerViewControllerStateProtocol {
        case phoneWhatsNew(WhatsNewViewController)
        case padWhatsNew(WhatsNewPadContainerViewController)
        case noWhatsNew(LoadedState)

        // MARK: computed properties
        internal var date: Date? {
            switch self {
                case .phoneWhatsNew, .padWhatsNew: return nil
                case .noWhatsNew(let state): return state.date
            }
        }

        internal var needsInitialLoad: Bool {
            switch self {
                case .phoneWhatsNew, .padWhatsNew: return false
                case .noWhatsNew(let state): return state.needsInitialLoad
            }
        }

        internal var viewController: UIViewController {
            switch self {
                case .phoneWhatsNew(let vc): return vc
                case .padWhatsNew(let vc): return vc
                case .noWhatsNew(let state): return state.viewController
            }
        }
    }

    // MARK: properties
    internal lazy var state = makeInitialState()
    internal var containerView: UIView {
        return view
    }

    private let disposeBag = DisposeBag()
    private let initialLoad = Singular()

    internal let darkSkyClient = DarkSkyClient()
    internal let appLookupClient = AppLookupClient()
    internal let forecastController = ForecastController()
    internal var fetcherDisposeBag = DisposeBag()

    private let locationsController: StoredLocationsController
    private let recentlySelected: Bool

    // MARK: init/deinit
    internal init(locationsController: StoredLocationsController, recentlySelected: Bool) {
        self.locationsController = locationsController
        self.recentlySelected = recentlySelected

        super.init()
    }

    // MARK: making
    private func makeLoadedState() -> LoadedState {
        let date = Date.now

        if let forecast = forecastController.cachedForecast(for: date, location: locationsController.defaultLocation) {
            let vc = makeLoadedViewController(
                date: date,
                locationsController: locationsController,
                timedForecast: forecast
            )

            return .loaded(vc, date: date)
        } else {
            return .loading(LoadingViewController(), date: date)
        }
    }

    private func makeInitialState() -> State {
        let controller = GlobalSettingsController.shared
        let settings = controller.retrieve()
        let currentVersion = Bundle.main.version
        let state = settings.whatsNewState(recentlySelectedLocation: recentlySelected)

        let updateSettingsClosure = {
            let newSettings = settings.with(\.lastWhatsNewVersionSeen, value: currentVersion)

            controller.save(newSettings)
        }
        
        let onDismissClosure = { [weak self] in
            updateSettingsClosure()

            self?.onWhatsNewDismissed()
        }

        switch state {
            case .showWhatsNew:
                switch InterfaceIdiom.current {
                    case .phone:
                        return .phoneWhatsNew(WhatsNewViewController(context: .launch(onDismiss: onDismissClosure)))
                    case .pad:
                        return .padWhatsNew(WhatsNewPadContainerViewController(onDismiss: onDismissClosure))
                }
            case .hideWhatsNew(updateSettings: let updateSettings):
                if updateSettings {
                    updateSettingsClosure()
                }

                return .noWhatsNew(makeLoadedState())
        }
    }

    private func makeLoadedViewController(
        date: Date,
        locationsController: StoredLocationsController,
        timedForecast: TimedForecast
    ) -> WeatherPagingViewController {
        return WeatherPagingViewController(
            today: date,
            locationsController: locationsController,
            timedForecast: timedForecast
        )
    }

    // MARK: setup
    private func setupViews() {
        view.add(fullscreenSubview: AppBackgroundView())
        
        setupInitialViewController(state.viewController, containerView: containerView)
    }

    private func setupObservers() {
        NotificationCenter.default.rx
            .notification(UIApplication.willEnterForegroundNotification)
            .subscribe(onNext: { [weak self] _ in
                self?.reloadIfNeeded()
            })
            .disposed(by: disposeBag)
    }

    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()

        view.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.mainView)

        setupViews()
        setupObservers()
    }

    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchInitialForecastIfNeeded()
    }

    // MARK: fetching
    private func fetchInitialForecastIfNeeded() {
        if state.needsInitialLoad {
            initialLoad.performOnce {
                fetchForecastWithCacheCheck()
            }
        }
    }

    private func fetchForecastWithCacheCheck() {
        fetchForecastWithCacheCheck(for: .now, location: locationsController.defaultLocation)
    }

    // MARK: reloading
    private func reloadIfNeeded() {
        guard let date = state.date else {
            return
        }

        // We don't care about timezones as we just use Date.now
        let calendar = Calendar.current

        // if the fetch date is not today, fetch forecast with the cache check
        if !date.isInSameDay(as: .now, using: calendar) {
            fetchForecastWithCacheCheck()
        } else if date.addingTimeInterval(ForecastType.present.cacheInterval) < .now {
            fetchForecastWithCacheCheck()
        }
    }

    // MARK: interface actions
    private func onWhatsNewDismissed() {
        let newState = makeLoadedState()

        transition(to: .noWhatsNew(newState))

        fetchInitialForecastIfNeeded()
    }

    // MARK: transition
    internal func transitionToLoadedState(
        with timedForecast: TimedForecast,
        date: Date,
        location: ValidLocation,
        onComplete: ((NCUpdateResult) -> Void)?
    ) {
        // We ignore the passed through location and use our locationsController
        let vc = makeLoadedViewController(
            date: date,
            locationsController: locationsController,
            timedForecast: timedForecast
        )

        transition(to: .noWhatsNew(.loaded(vc, date: date)))
    }

    internal func transitionToLoadingState(with date: Date) {
        transition(to: .noWhatsNew(.loading(LoadingViewController(), date: date)))
    }

    internal func transitionToErrorState(
        with date: Date,
        location: ValidLocation,
        onComplete: ((NCUpdateResult) -> Void)?
    ) {
        transition(to: .noWhatsNew(.errored(ErrorViewController(
            loadedViewControllerType: WeatherPagingViewController.self,
            onTap: { [weak self] in
                self?.fetchForecastWithCacheCheck()
            },
            onLoadComplete: onComplete
        ), date: date)))
    }
}
