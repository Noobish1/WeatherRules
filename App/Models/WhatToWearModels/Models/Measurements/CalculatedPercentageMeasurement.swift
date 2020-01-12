import Foundation
import WhatToWearCommonModels

// MARK: CalculatedPercentageMeasurement
public struct CalculatedPercentageMeasurement: PercentageMeasurementProtocol {
    // MARK: properties
    public let id: MeasurementID
    public let name: String
    public let basicValue: BasicMeasurementValue
    public let explanation: String
    public let symbol = DoubleSymbol.self
    public let calculation: (HourlyDataPoint, Forecast) -> Double?
    public let rawRange = Double(0)...Double(1)

    public func value(for dataPoint: HourlyDataPoint, in forecast: Forecast) -> Double? {
        return calculation(dataPoint, forecast)
    }
}

// MARK: Equatable
extension CalculatedPercentageMeasurement: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        // I have to have this for some reason
        // I include the constant members to future proof this
        // Can't include closures
        return  lhs.id == rhs.id && lhs.name == rhs.name &&
                lhs.symbol == rhs.symbol && lhs.rawRange == rhs.rawRange
    }
}
