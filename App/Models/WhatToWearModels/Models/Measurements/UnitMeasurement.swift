import Foundation
import WhatToWearCommonModels
import WhatToWearCore

// MARK: UnitMeasurement
public struct UnitMeasurement<DimensionType: Dimension>: DoubleMeasurementProtocol {
    // MARK: properties
    public let id: MeasurementID
    public let value: MeasurementValue<Measurement<DimensionType>?>
    public let name: String
    public let explanation: String
    public let symbol = DoubleSymbol.self
    public let rawRange: ClosedRange<Double>
    public let rawUnit: DimensionType
    public let displayedMetricUnit: DimensionType
    public let displayedImperialUnit: DimensionType

    // MARK: computed properties
    public var basicValue: BasicMeasurementValue {
        return value.basicValue
    }

    // MARK: converting displayedValue's to rawValues
    // The system passed in needs to be the same as the one that was used to make the displayedValue
    public func rawValue(forDisplayedValue displayedValue: DisplayedValue) -> Double {
        let displayedMeasurement: Measurement<DimensionType>

        switch displayedValue.system {
            case .metric:
                displayedMeasurement = Measurement(
                    value: displayedValue.value,
                    unit: displayedMetricUnit
                )
            case .imperial:
                displayedMeasurement = Measurement(
                    value: displayedValue.value,
                    unit: displayedImperialUnit
                )
        }

        return displayedMeasurement.converted(to: rawUnit).value
    }

    // MARK: retrieiving values from dataPoints
    public func value(for dataPoint: HourlyDataPoint, in forecast: Forecast) -> Double? {
        return value.retrieve(from: dataPoint, forecast: forecast)?.value
    }
}

// MARK: Equatable
extension UnitMeasurement: Equatable {
    // MARK: Equatable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return  lhs.id == rhs.id &&
                lhs.name == rhs.name && lhs.symbol == rhs.symbol &&
                lhs.rawRange == rhs.rawRange && lhs.rawUnit == rhs.rawUnit &&
                lhs.displayedMetricUnit == rhs.displayedMetricUnit &&
                lhs.displayedImperialUnit == rhs.displayedImperialUnit
    }
}
