import ErrorRecorder
import NotificationCenter
import UIKit
import WhatToWearCoreComponents
import WhatToWearCoreUI
import WhatToWearModels

public final class LocationContainerViewController<InnerViewController: ExtensionViewControllerProtocol>: CodeBackedViewController, ExtensionLocalContainerViewControllerProtocol {
    // MARK: State
    public enum State: ContainerViewControllerStateProtocol, Equatable, ExtensionLocalContainerStateProtocol {
        case noLocation(NoLocationViewController)
        case locationSet(InnerViewController)

        // MARK: computed properties
        public func asExtensionViewController() -> ExtensionViewControllerProtocol {
            switch self {
                case .noLocation(let vc): return vc
                case .locationSet(let vc): return vc
            }
        }

        public var viewController: UIViewController {
            switch self {
                case .noLocation(let vc): return vc
                case .locationSet(let vc): return vc
            }
        }

        // MARK: init
        internal init(
            params: LocationContainerParams,
            makeInnerViewController: @escaping (LoadingContainerParams) -> InnerViewController
        ) {
            if let location = LocationController.shared.retrieve()?.defaultLocation {
                let vc = makeInnerViewController(.init(locationContainerParams: params, location: location))
                self = .locationSet(vc)
            } else {
                self = .noLocation(NoLocationViewController(params: params))
            }
        }
    }

    // MARK: properties
    public var state: State
    public var containerView: UIView {
        return view
    }

    private let initialParams: LocationContainerParams
    private let makeInnerViewController: (LoadingContainerParams) -> InnerViewController
    
    // MARK: init
    public init(
        params: LocationContainerParams,
        makeInnerViewController: @escaping (LoadingContainerParams) -> InnerViewController
    ) {
        self.state = State(params: params, makeInnerViewController: makeInnerViewController)
        self.initialParams = params
        self.makeInnerViewController = makeInnerViewController

        super.init()
    }

    // MARK: setup
    private func setupViews() {
        view.add(fullscreenSubview: AppBackgroundView())
        
        setupInitialViewController(state.viewController, containerView: containerView)
    }

    // MARK: UIViewController
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    // MARK: making states
    public func makeState(
        with completionHandler: @escaping ((NCUpdateResult) -> Void)
    ) -> State {
        return State(
            params: initialParams.with(\.onLoadComplete, value: completionHandler),
            makeInnerViewController: makeInnerViewController
        )
    }
}
