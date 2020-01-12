import Foundation
import WhatToWearModels

// MARK: RuleViewModel
internal struct RuleViewModel: Equatable {
    // MARK: properties
    internal let title: String
    internal let conditions: [ConditionViewModel]
    internal let underlyingModel: Rule
    internal let isExisting: Bool

    // MARK: init
    internal init(rule: Rule, system: MeasurementSystem, isExisting: Bool) {
        self.title = rule.name
        self.conditions = rule.conditions.map {
            ConditionViewModel(condition: $0, system: system)
        }
        self.underlyingModel = rule
        self.isExisting = isExisting
    }
}
