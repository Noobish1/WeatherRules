import NotificationCenter
import RxSwift
import UIKit
import WhatToWearCore
import WhatToWearCoreComponents
import WhatToWearCoreUI
import WhatToWearModels
import WhatToWearNetworking

public final class RulesContainerViewController: CodeBackedViewController, ExtensionLocalContainerViewControllerProtocol, ForecastBasedViewControllerProtocol {
    // MARK: State
    public enum State: ContainerViewControllerStateProtocol, ExtensionLocalContainerStateProtocol {
        case noRules(NoRulesViewController)
        case maybeRules(ForecastLoadingViewController<MaybeRulesViewController>)

        // MARK: init
        public init(
            params: LoadingContainerParams,
            storedRules: StoredRules,
            onLoadComplete: ((NCUpdateResult) -> Void)?
        ) {
            guard let nonEmptyStoredRules = NonEmptyStoredRules(storedRules: storedRules) else {
                self = .noRules(NoRulesViewController(
                    state: .noRules, extensionType: params.extensionType, onLoadComplete: onLoadComplete
                ))

                return
            }
            
            let newParams = params.with(\.onLoadComplete, value: onLoadComplete)
            
            self = .maybeRules(
                ForecastLoadingViewController(
                    params: newParams,
                    makeInnerViewController: { params in
                        MaybeRulesViewController(storedRules: nonEmptyStoredRules, params: params)
                    }
                )
            )
        }

        // MARK: computed properties
        public var viewController: UIViewController {
            switch self {
                case .noRules(let vc): return vc
                case .maybeRules(let vc): return vc
            }
        }

        // MARK: ExtensionLocalContainerStateProtocol
        public func asExtensionViewController() -> ExtensionViewControllerProtocol {
            switch self {
                case .noRules(let vc): return vc
                case .maybeRules(let vc): return vc
            }
        }
    }

    // MARK: properties
    public var state: State
    public var containerView: UIView {
        return view
    }

    private let initialParams: LoadingContainerParams

    // MARK: init
    public init(params: LoadingContainerParams) {
        self.initialParams = params
        self.state = State(
            params: params,
            storedRules: RulesController.shared.retrieve(),
            onLoadComplete: params.onLoadComplete
        )

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

    // MARK: Making state
    public func makeState(
        with completionHandler: @escaping ((NCUpdateResult) -> Void)
    ) -> State {
        return State(
            params: initialParams,
            storedRules: RulesController.shared.retrieve(),
            onLoadComplete: completionHandler
        )
    }
    
    // MARK: handling unchanged forecasts
    public func handleUnchangedForecast(_ timedForecast: TimedForecast, onComplete: ((NCUpdateResult) -> Void)?) {
        switch state {
            case .noRules: break
            case .maybeRules(let vc): vc.handleUnchangedForecast(timedForecast, onComplete: onComplete)
        }
    }
}
