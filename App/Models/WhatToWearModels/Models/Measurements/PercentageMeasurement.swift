import Foundation
import WhatToWearCommonModels
import WhatToWearCore

// MARK: PercentageMeasurement
public struct PercentageMeasurement: PercentageMeasurementProtocol {
    // MARK: properties
    public let id: MeasurementID
    public let value: MeasurementValue<Percentage<Double>?>
    public let name: String
    public let explanation: String
    public let symbol = DoubleSymbol.self
    public let rawRange = Double(0)...Double(1)

    // MARK: computed properties
    public var basicValue: BasicMeasurementValue {
        return value.basicValue
    }

    // MARK: retrieving values from datapoints
    public func value(for dataPoint: HourlyDataPoint, in forecast: Forecast) -> Double? {
        return value.retrieve(from: dataPoint, forecast: forecast)?.rawValue
    }
}

// MARK: Equatable
extension PercentageMeasurement: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        // I have to have this for some reason
        // I include the constant members to future proof this
        return  lhs.id == rhs.id && lhs.name == rhs.name &&
                lhs.symbol == rhs.symbol && lhs.rawRange == rhs.rawRange
    }
}
