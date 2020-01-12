import Foundation

public protocol ContainerViewProtocol: UIView {}

extension ContainerViewProtocol {
    // MARK: setup
    public func setupInitialView(_ view: UIView) {
        self.addChildView(view)
    }

    // MARK: adding/removing children
    public func addChildView(_ view: UIView) {
        add(fullscreenSubview: view)
    }

    public func removeChildView(_ view: UIView) {
        view.removeFromSuperview()
    }

    // MARK: transitions
    public func transitionFromView(_ fromView: UIView, toView: UIView) {
        addChildView(toView)
        removeChildView(fromView)
    }
}
