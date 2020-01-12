import WhatToWearCommonCore
import WhatToWearCore
import WhatToWearCoreUI

internal final class RuleAdditionContainerView<FullView: RuleAdditionFullViewProtocol>: CodeBackedView, FullnessContainerView {
    // MARK: properties
    internal let configureEmptyView: (RuleEmptyView) -> Void
    internal let configureFullView: (FullView) -> Void
    internal let emptyConfig: RuleEmptyView.Config
    
    internal var state: FullnessState<RuleEmptyView, FullView>
    
    // MARK: init
    internal init(
        viewModels: [FullView.ViewModel],
        configureEmptyView: @escaping (RuleEmptyView) -> Void,
        configureFullView: @escaping (FullView) -> Void,
        emptyConfig: RuleEmptyView.Config
    ) {
        self.state = State(viewModels: viewModels, emptyConfig: emptyConfig)
        self.configureEmptyView = configureEmptyView
        self.configureFullView = configureFullView
        self.emptyConfig = emptyConfig
        
        super.init(frame: .zero)
        
        setupInitialViews(for: state)
    }
    
    // MARK: update
    internal func update(with viewModels: [FullView.ViewModel]) {
        if let nonEmptyViewModels = NonEmptyArray(array: viewModels) {
            switch state {
                case .full(let fullVC):
                    fullVC.update(with: nonEmptyViewModels)
                case .empty:
                    transition(to: .full(FullView(viewModels: nonEmptyViewModels)))
            }
        } else {
            switch state {
                case .full:
                    transition(to: .empty(RuleEmptyView(config: emptyConfig)))
                case .empty:
                    break
            }
        }
    }
}
