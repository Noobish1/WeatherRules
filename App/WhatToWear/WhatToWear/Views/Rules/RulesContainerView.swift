import UIKit
import WhatToWearCoreUI
import WhatToWearModels

internal final class RulesContainerView: CodeBackedView, FullnessContainerView {
    // MARK: properties
    internal let configureEmptyView: (RuleEmptyView) -> Void
    internal let configureFullView: (RulesFullView) -> Void
    internal var state: FullnessState<RuleEmptyView, RulesFullView>

    // MARK: init
    internal init(
        rules: StoredRules,
        system: MeasurementSystem,
        configureEmptyView: @escaping (RuleEmptyView) -> Void,
        configureFullView: @escaping (RulesFullView) -> Void
    ) {
        self.state = Self.makeState(rules: rules, system: system)
        self.configureEmptyView = configureEmptyView
        self.configureFullView = configureFullView

        super.init(frame: .zero)

        setupInitialViews(for: state)
    }

    // MARK: init helpers
    private static func makeState(rules: StoredRules, system: MeasurementSystem) -> State {
        if let nonEmptyRules = NonEmptyStoredRules(storedRules: rules) {
            return .full(RulesFullView(storedRules: nonEmptyRules, system: system))
        } else {
            return .empty(RuleEmptyView(config: .rules))
        }
    }

    // MARK: update
    internal func update(with rules: StoredRules, system: MeasurementSystem) {
        if let nonEmptyRules = NonEmptyStoredRules(storedRules: rules) {
            switch state {
                case .full(let fullVC):
                    fullVC.update(with: nonEmptyRules, system: system)
                case .empty:
                    transition(to: .full(RulesFullView(
                        storedRules: nonEmptyRules, system: system
                    )))
            }
        } else {
            switch state {
                case .full:
                    transition(to: .empty(RuleEmptyView(config: .rules)))
                case .empty:
                    break
            }
        }
    }
}
