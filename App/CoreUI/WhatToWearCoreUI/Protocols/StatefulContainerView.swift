import Foundation

public protocol StatefulContainerView: ContainerViewProtocol {
    associatedtype State: ContainerViewStateProtocol

    var state: State { get set }

    func transition(to newState: State)
}

extension StatefulContainerView {
    public func transition(to newState: State) {
        guard newState != state else {
            return
        }

        let fromView = self.state.view
        let toView = newState.view

        transitionFromView(fromView, toView: toView)

        self.state = newState
    }
}
