import Foundation
import WhatToWearCommonModels
import WhatToWearCore

// MARK: BaseCondition
internal enum BaseCondition: String, Codable {
    case double = "double"
    case precipType = "precipType"
    case time = "time"
    case windDirection = "windDirection"
    case dayOfWeek = "dayOfWeek"
}

// MARK: Condition
public enum Condition: Equatable {
    case double(DoubleCondition)
    case time(TimeCondition)
    case enumeration(EnumCondition)
}

// MARK: computed properties
extension Condition {
    private var baseCondition: BaseCondition {
        switch self {
            case .double: return .double
            case .enumeration(let condition): return condition.baseCondition
            case .time: return .time
        }
    }

    public var measurement: WeatherMeasurement {
        switch self {
            case .double(let condition):
                return .double(condition.measurement)
            case .time(let condition):
                return .time(condition.measurement)
            case .enumeration(let condition):
                return condition.measurement
        }
    }
}

// MARK: BasicConditionProtocol
extension Condition: BasicConditionProtocol {
    // MARK: computed properties
    private var wrapper: BasicConditionProtocol {
        switch self {
            case .double(let condition): return condition
            case .enumeration(let condition): return condition.wrapper
            case .time(let condition): return condition
        }
    }

    // MARK: meeting
    public func isMetBy(dataPoint: HourlyDataPoint, for forecast: Forecast) -> Bool {
        return wrapper.isMetBy(dataPoint: dataPoint, for: forecast)
    }
}

// MARK: Codable
extension Condition: Codable {
    public enum CodingKeys: String, CodingKey {
        case base = "base"
        case double = "double"
        case precipType = "precipType"
        case time = "time"
        case windDirection = "windDirection"
        case dayOfWeek = "dayOfWeek"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let base = try container.decode(BaseCondition.self, forKey: .base)

        try self.init(with: base, from: container)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(baseCondition, forKey: .base)
        try encodeConditon(into: &container)
    }
}

// MARK: Encoding/Decoding
extension Condition {
    // MARK: decoding
    private init(
        with base: BaseCondition,
        from container: KeyedDecodingContainer<Condition.CodingKeys>
    ) throws {
        switch base {
            case .double:
                self = .double(try container.decode(DoubleCondition.self, forKey: .double))
            case .precipType:
                self = .enumeration(.precipType(
                    try container.decode(SelectableCondition<PrecipitationType>.self, forKey: .precipType)
                ))
            case .time:
                self = .time(try container.decode(TimeCondition.self, forKey: .time))
            case .windDirection:
                self = .enumeration(.windDirection(
                    try container.decode(SelectableCondition<WindDirection>.self, forKey: .windDirection)
                ))
            case .dayOfWeek:
                self = .enumeration(.dayOfWeek(
                    try container.decode(SelectableCondition<DayOfWeek>.self, forKey: .dayOfWeek)
                ))
        }
    }

    // MARK: encoding
    private func encodeConditon(
        into container: inout KeyedEncodingContainer<Condition.CodingKeys>
    ) throws {
        switch self {
            case .double(let doubleCondition):
                try container.encode(doubleCondition, forKey: .double)
            case .enumeration(.precipType(let precipCondition)):
                try container.encode(precipCondition, forKey: .precipType)
            case .time(let timeCondition):
                try container.encode(timeCondition, forKey: .time)
            case .enumeration(.windDirection(let windCondition)):
                try container.encode(windCondition, forKey: .windDirection)
            case .enumeration(.dayOfWeek(let dayOfWeekCondition)):
                try container.encode(dayOfWeekCondition, forKey: .dayOfWeek)
        }
    }
}
