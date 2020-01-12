import Foundation
import WhatToWearCommonModels

public enum EnumCondition: Equatable {
    case precipType(SelectableCondition<PrecipitationType>)
    case windDirection(SelectableCondition<WindDirection>)
    case dayOfWeek(SelectableCondition<DayOfWeek>)

    // MARK: computed properties
    internal var baseCondition: BaseCondition {
        switch self {
            case .precipType: return .precipType
            case .windDirection: return .windDirection
            case .dayOfWeek: return .dayOfWeek
        }
    }

    public var measurement: WeatherMeasurement {
        switch self {
            case .precipType(let condition):
                return .enumeration(.precipType(condition.measurement))
            case .windDirection(let condition):
                return .enumeration(.windDirection(condition.measurement))
            case .dayOfWeek(let condition):
                return .enumeration(.dayOfWeek(condition.measurement))
        }
    }

    public var symbol: SelectableMeasurementSymbol {
        switch self {
            case .precipType(let condition):
                return condition.symbol
            case .windDirection(let condition):
                return condition.symbol
            case .dayOfWeek(let condition):
                return condition.symbol
        }
    }

    internal var wrapper: BasicConditionProtocol {
        switch self {
            case .precipType(let condition): return condition
            case .windDirection(let condition): return condition
            case .dayOfWeek(let condition): return condition
        }
    }
}
