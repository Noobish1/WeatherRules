import Foundation
import WhatToWearCommonModels
import WhatToWearCore

// MARK: RawDoubleMeasurement
public struct RawDoubleMeasurement: DoubleMeasurementProtocol {
    // MARK: properties
    public let id: MeasurementID
    public let value: MeasurementValue<Double?>
    public let name: String
    public let explanation: String
    public let symbol = DoubleSymbol.self
    public let rawRange = -Double.infinity...Double.infinity

    // MARK: computed properties
    public var basicValue: BasicMeasurementValue {
        return value.basicValue
    }

    // MARK: converting between raw and displayed value
    public func rawValue(forDisplayedValue displayedValue: DisplayedValue) -> Double {
        return displayedValue.value
    }

    // MARK: values from datapoints
    public func value(for dataPoint: HourlyDataPoint, in forecast: Forecast) -> Double? {
        return value.retrieve(from: dataPoint, forecast: forecast)
    }
}

// MARK: Equatable
extension RawDoubleMeasurement: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        // I have to have this for some reason
        // I include the constant members to future proof this
        return  lhs.id == rhs.id &&
                lhs.name == rhs.name && lhs.symbol == rhs.symbol &&
                lhs.rawRange == rhs.rawRange
    }
}
