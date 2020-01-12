import Foundation
import WhatToWearModels

internal enum DoubleConditionViewModel {
    internal static func title(for condition: DoubleCondition, system: MeasurementSystem) -> String {
        let symbolTitle = DoubleSymbolViewModel.shortTitle(for: condition.symbol)
        
        let displayedValueWithUnits = DoubleMeasurementViewModel.displayedStringValueWithUnits(
            for: condition.measurement, rawValue: condition.value, system: system
        )

        return "\(condition.measurement.name) \(symbolTitle) \(displayedValueWithUnits)"
    }
}
