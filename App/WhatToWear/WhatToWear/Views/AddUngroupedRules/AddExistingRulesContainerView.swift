import UIKit
import WhatToWearCommonCore
import WhatToWearCore
import WhatToWearCoreUI

internal final class AddExistingRulesContainerView: CodeBackedView, FullnessContainerView {
    // MARK: properties
    private let onRulesSelected: (NonEmptyArray<RuleViewModel>) -> Void
    private let onNoRulesSelected: () -> Void

    internal let configureEmptyView: (AddExistingRulesEmptyView) -> Void
    internal let configureFullView: (AddExistingRulesFullView) -> Void
    internal var state: FullnessState<AddExistingRulesEmptyView, AddExistingRulesFullView>

    // MARK: init
    internal init(
        rules: [RuleViewModel],
        onRulesSelected: @escaping (NonEmptyArray<RuleViewModel>) -> Void,
        onNoRulesSelected: @escaping () -> Void,
        configureEmptyView: @escaping (AddExistingRulesEmptyView) -> Void,
        configureFullView: @escaping (AddExistingRulesFullView) -> Void
    ) {
        self.state = Self.makeState(
            from: rules,
            onRulesSelected: onRulesSelected,
            onNoRulesSelected: onNoRulesSelected
        )
        self.onRulesSelected = onRulesSelected
        self.onNoRulesSelected = onNoRulesSelected
        self.configureEmptyView = configureEmptyView
        self.configureFullView = configureFullView

        super.init(frame: .zero)

        setupInitialViews(for: state)
    }

    // MARK: init helpers
    private static func makeState(
        from rules: [RuleViewModel],
        onRulesSelected: @escaping (NonEmptyArray<RuleViewModel>) -> Void,
        onNoRulesSelected: @escaping () -> Void
    ) -> State {
        if let nonEmptyRules = NonEmptyArray(array: rules) {
            return .full(AddExistingRulesFullView(
                rules: nonEmptyRules,
                onRulesSelected: onRulesSelected,
                onNoRulesSelected: onNoRulesSelected
            ))
        } else {
            return .empty(AddExistingRulesEmptyView())
        }
    }

    // MARK: update
    internal func update(with rules: [RuleViewModel]) {
        if let nonEmptyRules = NonEmptyArray(array: rules) {
            switch state {
                case .full(let fullView):
                    fullView.update(with: nonEmptyRules)
                case .empty:
                    transition(to: .full(AddExistingRulesFullView(
                        rules: nonEmptyRules,
                        onRulesSelected: onRulesSelected,
                        onNoRulesSelected: onNoRulesSelected
                    )))
            }
        } else {
            switch state {
                case .full:
                    transition(to: .empty(AddExistingRulesEmptyView()))
                case .empty:
                    break
            }
        }
    }

    internal func update(bottomInset: CGFloat) {
        switch state {
            case .full(let fullView):
                fullView.update(bottomInset: bottomInset)
            case .empty(let emptyView):
                emptyView.update(bottomInset: bottomInset)
        }
    }
}
