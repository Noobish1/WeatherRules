import Foundation
import WhatToWearCommonModels

public struct SelectableCondition<Value: SelectableConditionValueProtocol>: ConditionProtocol, Equatable {
    // MARK: Properties
    public let measurement: SelectableMeasurement<Value>
    public let symbol: SelectableMeasurementSymbol = .equalTo
    public let value: Value
    
    // MARK: init
    public init(measurement: SelectableMeasurement<Value>, value: Value) {
        self.measurement = measurement
        self.value = value
    }
    
    public init(
        measurement: SelectableMeasurement<Value>,
        symbol: SelectableMeasurementSymbol,
        value: Value
    ) {
        self.init(measurement: measurement, value: value)
    }
    
    // MARK: measurements
    public static func specializedMeasurement(from wrapper: WeatherMeasurement) -> SelectableMeasurement<Value>? {
        return Value.specializedMeasurement(from: wrapper)
    }
    
    // MARK: meeting
    public func isMetBy(dataPoint: HourlyDataPoint, for forecast: Forecast) -> Bool {
        return measurement.value.retrieve(from: dataPoint, forecast: forecast) == value
    }
}
