import Foundation
import WhatToWearCore
import WhatToWearModels

internal enum UnitMeasurementViewModel {
    // MARK: static displayed strings
    internal static func displayedUnitSymbolString<DimensionType>(for measurement: UnitMeasurement<DimensionType>, system: MeasurementSystem) -> String {
        let formatter = MeasurementFormatters.unitFormatter

        switch system {
            case .metric:
                return formatter.string(from: measurement.displayedMetricUnit)
            case .imperial:
                return formatter.string(from: measurement.displayedImperialUnit)
        }
    }
    
    internal static func title<DimensionType>(for measurement: UnitMeasurement<DimensionType>, system: MeasurementSystem) -> String {
        return "\(measurement.name) (\(displayedUnitSymbolString(for: measurement, system: system)))"
    }
    
    internal static func displayedStringValueWithUnits<DimensionType>(
        for measurement: UnitMeasurement<DimensionType>,
        rawValue: Double,
        system: MeasurementSystem
    ) -> String {
        let dMeasurement = displayedMeasurement(for: measurement, rawValue: rawValue, system: system)
        let formatter = MeasurementFormatters.measurementFormatter

        return formatter.string(from: dMeasurement)
    }
    
    // MARK: displayed strings
    internal static func displayedMeasurement<DimensionType>(
        for measurement: UnitMeasurement<DimensionType>,
        rawValue: Double,
        system: MeasurementSystem
    ) -> Measurement<DimensionType> {
        let rawMeasurement = Measurement<DimensionType>(value: rawValue, unit: measurement.rawUnit)

        switch system {
            case .metric:
                return rawMeasurement.converted(to: measurement.displayedMetricUnit)
            case .imperial:
                return rawMeasurement.converted(to: measurement.displayedImperialUnit)
        }
    }
}
