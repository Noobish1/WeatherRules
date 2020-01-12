import UIKit

public protocol StatefulContainerViewController: ContainerViewControllerProtocol {
    associatedtype State: ContainerViewControllerStateProtocol

    var state: State { get set }

    func transition(to newState: State)
}

extension StatefulContainerViewController {
    public func transition(to newState: State) {
        guard newState != state else {
            return
        }

        let fromVC = self.state.viewController
        let toVC = newState.viewController

        transitionFromViewController(fromVC, toViewController: toVC, containerView: containerView)

        self.state = newState
    }
}
