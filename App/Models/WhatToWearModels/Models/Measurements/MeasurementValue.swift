import Foundation
import WhatToWearCommonModels

// MARK: BasicMeasurementValue
public enum BasicMeasurementValue {
    case hourly
    case daily
}

// MARK: MeasurementValue
public enum MeasurementValue<Value> {
    case hourly((HourlyDataPoint) -> Value)
    case daily((DailyData) -> Value)

    // MARK: computed properties
    public var basicValue: BasicMeasurementValue {
        switch self {
            case .hourly: return .hourly
            case .daily: return .daily
        }
    }

    // MARK: retrieval
    public func retrieve(from dataPoint: HourlyDataPoint, forecast: Forecast) -> Value {
        switch self {
            case .hourly(let closure): return closure(dataPoint)
            case .daily(let closure): return closure(forecast.daily.data)
        }
    }
}
