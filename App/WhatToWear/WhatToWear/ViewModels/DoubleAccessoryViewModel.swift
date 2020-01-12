import Foundation
import WhatToWearCore
import WhatToWearModels

internal struct DoubleAccessoryViewModel {
    // MARK: properties
    private let measurement: DoubleMeasurement
    private let system: MeasurementSystem
    
    internal let title: String
    internal let displayedRange: ClosedRange<Double>
    
    // MARK: init
    internal init(measurement: DoubleMeasurement, system: MeasurementSystem) {
        self.measurement = measurement
        self.system = system
        self.title = Self.title(for: measurement, system: system)
        self.displayedRange = Self.displayedRange(for: measurement, system: system)
    }
    
    // MARK: static init helpers
    private static func displayedMeasurement<DimensionType>(
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

    private static func displayedValue<DimensionType>(
        for measurement: UnitMeasurement<DimensionType>,
        rawValue: Double,
        system: MeasurementSystem
    ) -> DisplayedValue {
        let dMeasurement = displayedMeasurement(for: measurement, rawValue: rawValue, system: system)

        return DisplayedValue(value: dMeasurement.value, system: system)
    }
    
    private static func displayedValue(
        for measurement: DoubleMeasurement,
        rawValue: Double,
        system: MeasurementSystem
    ) -> DisplayedValue {
        switch measurement {
            case .percentage, .calculatedPercentage:
                // Raw values are metric
                return DisplayedValue(value: rawValue * 100, system: .metric)
            case .rawDouble:
                // raw values are metric
                return DisplayedValue(value: rawValue, system: .metric)
            case .temperature(let unitMeasurement):
                return displayedValue(for: unitMeasurement, rawValue: rawValue, system: system)
            case .angle(let unitMeasurement):
                return displayedValue(for: unitMeasurement, rawValue: rawValue, system: system)
            case .speed(let unitMeasurement):
                return displayedValue(for: unitMeasurement, rawValue: rawValue, system: system)
            case .length(let unitMeasurement):
                return displayedValue(for: unitMeasurement, rawValue: rawValue, system: system)
            case .pressure(let unitMeasurement):
                return displayedValue(for: unitMeasurement, rawValue: rawValue, system: system)
        }
    }
    
    private static func displayedRange(for measurement: DoubleMeasurement, system: MeasurementSystem) -> ClosedRange<Double> {
        let lowerbound = displayedValue(for: measurement, rawValue: measurement.rawRange.lowerBound, system: system)
        let upperbound = displayedValue(for: measurement, rawValue: measurement.rawRange.upperBound, system: system)

        return lowerbound.value...upperbound.value
    }
    
    private static func displayedRangeString<DimensionType>(for measurement: UnitMeasurement<DimensionType>, system: MeasurementSystem) -> String {
        let formatter = MeasurementFormatters.measurementFormatter
        let lowerMeasurement = displayedMeasurement(
            for: measurement,
            rawValue: measurement.rawRange.lowerBound,
            system: system
        )
        let upperMeasurement = displayedMeasurement(
            for: measurement,
            rawValue: measurement.rawRange.upperBound,
            system: system
        )

        return "\(lowerMeasurement.value)...\(formatter.string(from: upperMeasurement))"
    }
    
    private static func title(for measurement: DoubleMeasurement, system: MeasurementSystem) -> String {
        switch measurement {
            case .percentage, .calculatedPercentage, .rawDouble:
                let range = displayedRange(for: measurement, system: system)

                return "\(range.lowerBound)...\(range.upperBound)%"
            case .temperature(let unitMeasurement):
                return displayedRangeString(for: unitMeasurement, system: system)
            case .angle(let unitMeasurement):
                return displayedRangeString(for: unitMeasurement, system: system)
            case .speed(let unitMeasurement):
                return displayedRangeString(for: unitMeasurement, system: system)
            case .length(let unitMeasurement):
                return displayedRangeString(for: unitMeasurement, system: system)
            case .pressure(let unitMeasurement):
                return displayedRangeString(for: unitMeasurement, system: system)
        }
    }
    
    // MARK: displayedValues from other values
    internal func displayedValueString(for value: Double?) -> String? {
        return value
            .map { rawValue in
                Self.displayedValue(for: measurement, rawValue: rawValue, system: system)
            }
            .map { displayedValue in
                String(displayedValue.value)
            }
    }
    
    internal func displayedValue(fromTextFieldText text: String?) -> DisplayedValue? {
        guard
            let displayedValue = text.flatMap(Double.init),
            displayedRange.contains(displayedValue)
        else {
            return nil
        }

        return DisplayedValue(value: displayedValue, system: system)
    }
}
