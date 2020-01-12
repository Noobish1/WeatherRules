import Foundation
import WhatToWearModels

internal protocol PercentageMeasurementViewModelProtocol {
    associatedtype Measurement: PercentageMeasurementProtocol
}

extension PercentageMeasurementViewModelProtocol {
    // MARK: titles
    internal static func title(for measurement: Measurement) -> String {
        return "\(measurement.name) (%)"
    }
    
    // MARK: displayed strings
    internal static func displayedStringValueWithUnits(for measurement: Measurement, rawValue: Double, system: MeasurementSystem) -> String {
        // Raw values are always metric
        let value = DisplayedValue(value: rawValue * 100, system: .metric).value

        return "\(value)%"
    }
}
