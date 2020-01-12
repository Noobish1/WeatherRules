import UIKit

public protocol FullnessContainerView: StatefulContainerView {
    associatedtype EmptyView: UIView
    associatedtype FullView: UIView
    associatedtype State = FullnessState<EmptyView, FullView>

    var configureEmptyView: (EmptyView) -> Void { get }
    var configureFullView: (FullView) -> Void { get }
    var state: FullnessState<EmptyView, FullView> { get set }

    func configureView(for state: FullnessState<EmptyView, FullView>)
    func setupInitialViews(for state: FullnessState<EmptyView, FullView>)
}

extension FullnessContainerView {
    // MARK: setup
    public func setupInitialViews(for state: FullnessState<EmptyView, FullView>) {
        setupInitialView(state.view)
        configureView(for: state)
    }

    // MARK: configuration
    public func configureView(for state: FullnessState<EmptyView, FullView>) {
        switch state {
            case .empty(let emptyView):
                configureEmptyView(emptyView)
            case .full(let fullView):
                configureFullView(fullView)
        }
    }

    // MARK: transition
    public func transition(to newState: FullnessState<EmptyView, FullView>) {
        guard newState != state else {
            return
        }

        let fromView = self.state.view
        let toView = newState.view

        transitionFromView(fromView, toView: toView)
        configureView(for: newState)

        self.state = newState
    }
}
