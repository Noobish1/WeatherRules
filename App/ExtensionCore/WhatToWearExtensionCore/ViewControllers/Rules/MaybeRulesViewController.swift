import Foundation
import NotificationCenter
import WhatToWearCommonCore
import WhatToWearCore
import WhatToWearCoreComponents
import WhatToWearCoreUI
import WhatToWearModels

public final class MaybeRulesViewController: CodeBackedViewController, StatefulContainerViewController, ForecastBasedViewControllerProtocol {
    // MARK: state
    public enum State: ContainerViewControllerStateProtocol {
        case noMetRules(NoRulesViewController)
        case metRules(MetRulesViewController)

        // MARK: init
        public init(
            timedForecast: TimedForecast,
            storedRules: NonEmptyStoredRules,
            extensionType: ExtensionType,
            setPreferredContentSize: @escaping (CGSize) -> Void,
            onLoadComplete: ((NCUpdateResult) -> Void)?
        ) {
            let timeSettings = TimeSettingsController.shared.retrieve()

            guard let finalViewModels = RulesState.finalViewModels(
                for: timeSettings,
                storedRules: storedRules,
                timedForecast: timedForecast
            ) else {
                let vc = NoRulesViewController(
                    state: .noMetRules,
                    extensionType: extensionType,
                    onLoadComplete: onLoadComplete
                )

                self = .noMetRules(vc)

                return
            }

            self = .metRules(MetRulesViewController(
                viewModels: finalViewModels,
                extensionType: extensionType,
                setPreferredContentSize: setPreferredContentSize,
                onLoadComplete: onLoadComplete
            ))
        }

        // MARK: computed properties
        public var viewController: UIViewController {
            switch self {
                case .noMetRules(let vc): return vc
                case .metRules(let vc): return vc
            }
        }

        public func asExtensionViewController() -> ExtensionViewControllerProtocol {
            switch self {
                case .noMetRules(let vc): return vc
                case .metRules(let vc): return vc
            }
        }
    }

    // MARK: properties
    public var state: State
    public var containerView: UIView {
        return view
    }

    public let setPreferredContentSize: (CGSize) -> Void
    private let storedRules: NonEmptyStoredRules
    private let extensionType: ExtensionType

    // MARK: init
    public init(storedRules: NonEmptyStoredRules, params: ForecastLoadingParams) {
        self.storedRules = storedRules
        self.state = State(
            timedForecast: params.timedForecast,
            storedRules: storedRules,
            extensionType: params.extensionType,
            setPreferredContentSize: params.setPreferredContentSize,
            onLoadComplete: params.onLoadComplete
        )
        self.extensionType = params.extensionType
        self.setPreferredContentSize = params.setPreferredContentSize

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

    // MARK: dealing with unchanged forecasts
    public func handleUnchangedForecast(
        _ timedForecast: TimedForecast,
        onComplete: ((NCUpdateResult) -> Void)?
    ) {
        let newState = State(
            timedForecast: timedForecast,
            storedRules: storedRules,
            extensionType: extensionType,
            setPreferredContentSize: setPreferredContentSize,
            onLoadComplete: onComplete
        )

        transition(to: newState)
    }

    // MARK: widget
    public func preferredContentSize(
        for activeDisplayMode: NCWidgetDisplayMode,
        withMaximumSize maxSize: CGSize
    ) -> CGSize {
        return state.asExtensionViewController().preferredContentSize(
            for: activeDisplayMode,
            withMaximumSize: maxSize
        )
    }
}
