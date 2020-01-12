import Foundation
import WhatToWearCommonModels

// MARK: EnumMeasurement
public enum EnumMeasurement: Equatable {
    case precipType(SelectableMeasurement<PrecipitationType>)
    case windDirection(SelectableMeasurement<WindDirection>)
    case dayOfWeek(SelectableMeasurement<DayOfWeek>)

    // MARK: computed properties
    public var symbol: SelectableMeasurementSymbol.Type {
        switch self {
            case .precipType(let measurement): return measurement.symbol
            case .windDirection(let measurement): return measurement.symbol
            case .dayOfWeek(let measurement): return measurement.symbol
        }
    }
}

// MARK: BasicMeasurementProtocol
extension EnumMeasurement: BasicMeasurementProtocol {
    public var wrapper: BasicMeasurementProtocol {
        switch self {
            case .precipType(let measurement): return measurement
            case .windDirection(let measurement): return measurement
            case .dayOfWeek(let measurement): return measurement
        }
    }

    public var id: MeasurementID {
        return wrapper.id
    }

    public var basicValue: BasicMeasurementValue {
        return wrapper.basicValue
    }

    public var name: String {
        return wrapper.name
    }

    public var explanation: String {
        return wrapper.explanation
    }
}
