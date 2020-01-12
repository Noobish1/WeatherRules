import Foundation
import WhatToWearModels

internal enum DoubleMeasurementViewModel {
    // MARK: displayed strings
    internal static func displayedStringValueWithUnits(for measurement: DoubleMeasurement, rawValue: Double, system: MeasurementSystem) -> String {
        switch measurement {
            case .percentage(let measurement):
                return PercentageMeasurementViewModel.displayedStringValueWithUnits(for: measurement, rawValue: rawValue, system: system)
            case .calculatedPercentage(let measurement):
                return CalculatedPercentageMeasurementViewModel.displayedStringValueWithUnits(for: measurement, rawValue: rawValue, system: system)
            case .temperature(let measurement):
                return UnitMeasurementViewModel.displayedStringValueWithUnits(for: measurement, rawValue: rawValue, system: system)
            case .angle(let measurement):
                return UnitMeasurementViewModel.displayedStringValueWithUnits(for: measurement, rawValue: rawValue, system: system)
            case .speed(let measurement):
                return UnitMeasurementViewModel.displayedStringValueWithUnits(for: measurement, rawValue: rawValue, system: system)
            case .rawDouble(let measurement):
                return RawDoubleMeasurementViewModel.displayedStringValueWithUnits(for: measurement, rawValue: rawValue, system: system)
            case .length(let measurement):
                return UnitMeasurementViewModel.displayedStringValueWithUnits(for: measurement, rawValue: rawValue, system: system)
            case .pressure(let measurement):
                return UnitMeasurementViewModel.displayedStringValueWithUnits(for: measurement, rawValue: rawValue, system: system)
        }
    }
}
