import ErrorRecorder
import RxSwift
import SnapKit
import Then
import UIKit
import WhatToWearCore
import WhatToWearCoreComponents
import WhatToWearCoreUI
import WhatToWearModels

internal final class DayViewController: CodeBackedViewController, StatefulContainerViewController, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = DayViewController

        case mainView = "mainView"
    }

    // MARK: state
    internal enum State: ContainerViewControllerStateProtocol {
        case metRules(MetRulesViewController)
        case noRules(EmptyMetRulesViewController)
        case noMetRules(EmptyMetRulesViewController)

        // MARK: init
        fileprivate init(
            storedRules: StoredRules,
            timeSettings: TimeSettings,
            chartParams: WeatherChartView.Params,
            globalSettings: GlobalSettings,
            onLabelDoubleTap: @escaping () -> Void
        ) {
            switch RulesState(
                storedRules: storedRules,
                timedForecast: chartParams.forecast,
                timeSettings: timeSettings
            ) {
                case .metRules(let viewModels):
                    self = .metRules(
                        MetRulesViewController(
                            chartParams: chartParams,
                            settings: globalSettings,
                            viewModels: viewModels,
                            onLabelDoubleTap: onLabelDoubleTap
                        )
                    )
                case .noRules(labelText: let labelText):
                    self = .noRules(
                        EmptyMetRulesViewController(
                            chartParams: chartParams,
                            settings: globalSettings,
                            labelText: labelText,
                            onLabelDoubleTap: onLabelDoubleTap
                        )
                    )
            }
        }

        // MARK: computed properties
        internal var viewController: UIViewController {
            switch self {
                case .metRules(let vc): return vc
                case .noRules(let vc): return vc
                case .noMetRules(let vc): return vc
            }
        }
    }

    // MARK: properties
    internal var state: State
    internal var containerView: UIView {
        return view
    }
    private let disposeBag = DisposeBag()
    private let timedForecast: TimedForecast
    private let location: ValidLocation
    private let onLabelDoubleTap: () -> Void
    private let day: Date

    // MARK: status bar
    internal override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: init/deinit
    internal init(
        day: Date,
        timedForecast: TimedForecast,
        location: ValidLocation,
        onLabelDoubleTap: @escaping () -> Void
    ) {
        let globalSettings = GlobalSettingsController.shared.retrieve()

        self.day = day
        self.timedForecast = timedForecast
        self.location = location
        self.state = State(
            storedRules: RulesController.shared.retrieve(),
            timeSettings: TimeSettingsController.shared.retrieve(),
            chartParams: WeatherChartView.Params(
                day: day,
                currentTime: .now,
                forecast: timedForecast,
                location: location,
                settings: globalSettings
            ),
            globalSettings: globalSettings,
            onLabelDoubleTap: onLabelDoubleTap
        )
        self.onLabelDoubleTap = onLabelDoubleTap

        super.init()
    }

    // MARK: setup
    private func setupObservers() {
        RulesController.shared.relay
            .asDriver()
            .distinctUntilChanged()
            .skip(1)
            .drive(onNext: { [weak self] storedRules in
                guard let strongSelf = self else { return }

                let state = strongSelf.makeState(with: storedRules)

                strongSelf.transition(to: state)
            })
            .disposed(by: disposeBag)

        TimeSettingsController.shared.relay
            .asDriver()
            .distinctUntilChanged()
            .skip(1)
            .drive(onNext: { [weak self] timeSettings in
                guard let strongSelf = self else { return }

                let state = strongSelf.makeState(with: timeSettings)

                strongSelf.transition(to: state)
            })
            .disposed(by: disposeBag)

        GlobalSettingsController.shared.relay
            .asDriver()
            .distinctUntilChanged()
            .skip(1)
            .drive(onNext: { [weak self] settings in
                guard let strongSelf = self else { return }

                let state = strongSelf.makeState(with: settings)

                strongSelf.transition(to: state)
            })
            .disposed(by: disposeBag)
    }

    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()

        view.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.mainView)

        setupInitialViewController(state.viewController, containerView: containerView)
        setupObservers()
    }

    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Analytics.record(screen: .day)
    }

    // MARK: make
    private func makeState(with storedRules: StoredRules) -> State {
        return makeState(
            timeSettings: TimeSettingsController.shared.retrieve(),
            storedRules: storedRules,
            globalSettings: GlobalSettingsController.shared.retrieve()
        )
    }

    private func makeState(with timeSettings: TimeSettings) -> State {
        return makeState(
            timeSettings: timeSettings,
            storedRules: RulesController.shared.retrieve(),
            globalSettings: GlobalSettingsController.shared.retrieve()
        )
    }

    private func makeState(with globalSettings: GlobalSettings) -> State {
        return makeState(
            timeSettings: TimeSettingsController.shared.retrieve(),
            storedRules: RulesController.shared.retrieve(),
            globalSettings: globalSettings
        )
    }

    private func makeState(
        timeSettings: TimeSettings,
        storedRules: StoredRules,
        globalSettings: GlobalSettings
    ) -> State {
        return State(
            storedRules: storedRules,
            timeSettings: timeSettings,
            chartParams: WeatherChartView.Params(
                day: day,
                currentTime: .now,
                forecast: timedForecast,
                location: location,
                settings: globalSettings
            ),
            globalSettings: globalSettings,
            onLabelDoubleTap: onLabelDoubleTap
        )
    }
}
