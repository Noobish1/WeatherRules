import Foundation
import WhatToWearModels

internal enum EnumConditionViewModel {
    private static func title<T>(for condition: SelectableCondition<T>, symbol: SelectableMeasurementSymbol) -> String {
        let symbolTitle = SelectableMeasurementSymbolViewModel.shortTitle(for: symbol)
        
        return "\(condition.measurement.name) \(symbolTitle) \(condition.value)"
    }
    
    internal static func title(for condition: EnumCondition) -> String {
        switch condition {
            case .dayOfWeek(let dayOfWeekCondition):
                return title(for: dayOfWeekCondition, symbol: condition.symbol)
            case .precipType(let precipCondition):
                return title(for: precipCondition, symbol: condition.symbol)
            case .windDirection(let windCondition):
                return title(for: windCondition, symbol: condition.symbol)
        }
    }
}
