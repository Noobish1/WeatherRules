import Foundation
import WhatToWearCore
import WhatToWearModels

// MARK: ConditionViewModel
internal struct ConditionViewModel: Equatable {
    // MARK: properties
    internal let title: String
    internal let underlyingModel: Condition

    // MARK: init
    internal init(condition: Condition, system: MeasurementSystem) {
        self.underlyingModel = condition
        self.title = Self.title(for: condition, system: system)
    }
    
    // MARK: static init helpers
    internal static func title(for condition: Condition, system: MeasurementSystem) -> String {
        switch condition {
            case .double(let doubleCondition):
                return DoubleConditionViewModel.title(for: doubleCondition, system: system)
            case .time(let timeCondition):
                return TimeConditionViewModel.title(for: timeCondition)
            case .enumeration(let enumCondition):
                return EnumConditionViewModel.title(for: enumCondition)
        }
    }
}
