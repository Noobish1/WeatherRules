import Foundation
import WhatToWearCommonModels
import WhatToWearModels

internal enum EnumConditionTrio: Equatable {
    case precipType(
        measurement: SelectableMeasurement<PrecipitationType>,
        symbol: SelectableMeasurementSymbol,
        value: PrecipitationType?
    )
    case windDirection(
        measurement: SelectableMeasurement<WindDirection>,
        symbol: SelectableMeasurementSymbol,
        value: WindDirection?
    )
    case dayOfWeek(
        measurement: SelectableMeasurement<DayOfWeek>,
        symbol: SelectableMeasurementSymbol,
        value: DayOfWeek?
    )

    // MARK: init
    internal init(condition: EnumCondition) {
        switch condition {
            case .precipType(let condition):
                self = .precipType(
                    measurement: condition.measurement,
                    symbol: condition.symbol,
                    value: condition.value
                )
            case .windDirection(let condition):
                self = .windDirection(
                    measurement: condition.measurement,
                    symbol: condition.symbol,
                    value: condition.value
                )
            case .dayOfWeek(let condition):
                self = .dayOfWeek(
                    measurement: condition.measurement,
                    symbol: condition.symbol,
                    value: condition.value
                )
        }
    }

    internal init(measurement: EnumMeasurement, symbol: SelectableMeasurementSymbol) {
        switch measurement {
            case .precipType(let precipMeasurement):
                self = .precipType(
                    measurement: precipMeasurement,
                    symbol: symbol,
                    value: nil
                )
            case .windDirection(let windMeasurement):
                self = .windDirection(
                    measurement: windMeasurement,
                    symbol: symbol,
                    value: nil
                )
            case .dayOfWeek(let dayOfWeekMeasurement):
                self = .dayOfWeek(
                    measurement: dayOfWeekMeasurement,
                    symbol: symbol,
                    value: nil
                )
        }
    }
}
