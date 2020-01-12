import Foundation
import WhatToWearModels

// MARK: MeasurementSymbolPair
internal enum MeasurementSymbolPair: Equatable {
    case double(measurement: DoubleMeasurement, symbol: DoubleSymbol)
    case enumeration(measurement: EnumMeasurement, symbol: SelectableMeasurementSymbol)
    case time(measurement: TimeMeasurement, symbol: TimeMeasurement.Symbol)

    // MARK: computed properties
    internal var measurement: WeatherMeasurement {
        switch self {
            case .double(measurement: let measurement, symbol: _):
                return .double(measurement)
            case .enumeration(measurement: let measurement, symbol: _):
                return .enumeration(measurement)
            case .time(measurement: let measurement, symbol: _):
                return .time(measurement)
        }
    }
}
