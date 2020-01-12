import Foundation
import WhatToWearModels

internal enum ConditionTrio: Equatable {
    case double(measurement: DoubleMeasurement, symbol: DoubleSymbol, value: Double?)
    case time(measurement: TimeMeasurement, symbol: TimeSymbol, value: TimeRange?)
    case enumeration(EnumConditionTrio)

    // MARK: init
    internal init(condition wrapper: Condition) {
        switch wrapper {
            case .double(let condition):
                self = .double(
                    measurement: condition.measurement,
                    symbol: condition.symbol,
                    value: condition.value
                )
            case .time(let condition):
                self = .time(
                    measurement: condition.measurement,
                    symbol: condition.symbol,
                    value: condition.value
                )
            case .enumeration(let condition):
                self = .enumeration(EnumConditionTrio(condition: condition))
        }
    }

    internal init(pair: MeasurementSymbolPair) {
        switch pair {
            case .double(measurement: let measurement, symbol: let symbol):
                self = .double(measurement: measurement, symbol: symbol, value: nil)
            case .enumeration(measurement: let measurement, symbol: let symbol):
                self = .enumeration(EnumConditionTrio(measurement: measurement, symbol: symbol))
            case .time(measurement: let measurement, symbol: let symbol):
                self = .time(measurement: measurement, symbol: symbol, value: nil)
        }
    }
}
