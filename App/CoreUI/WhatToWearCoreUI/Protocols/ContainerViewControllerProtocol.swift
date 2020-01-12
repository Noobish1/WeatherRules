import SnapKit
import UIKit

public protocol ContainerViewControllerProtocol: UIViewController {
    var containerView: UIView { get }
    
    func setupContainerView()
}

extension ContainerViewControllerProtocol {
    // MARK: setup
    public func setupContainerView() {
        view.add(fullscreenSubview: containerView)
    }
    
    public func setupInitialViewController(
        _ viewController: UIViewController,
        containerView: UIView
    ) {
        self.addChildViewController(viewController, toContainerView: containerView)
    }

    // MARK: adding/removing children
    public func addChildViewController(
        _ viewController: UIViewController,
        toContainerView containerView: UIView
    ) {
        containerView.add(fullscreenSubview: viewController.view)

        self.addChild(viewController)

        viewController.didMove(toParent: self)
    }

    public func removeChildViewController(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }

    // MARK: transitions
    public func transitionFromViewController(
        _ fromViewController: UIViewController,
        toViewController: UIViewController,
        containerView: UIView
    ) {
        addChildViewController(toViewController, toContainerView: containerView)
        removeChildViewController(fromViewController)
    }
}
