import Foundation
import WhatToWearCore

public struct TimeSettings: Codable, Equatable, Withable {
    // MARK: Interval
    public enum Interval: String, FiniteSetValueProtocol {
        case hourly = "hourly"
        case fullDay = "fullDay"

        public var analyticsValue: String {
            // We don't localized analytics values
            switch self {
                case .hourly: return "Hourly"
                case .fullDay: return "Full Range"
            }
        }
    }

    // MARK: properties
    public var timeRange: TimeRange
    public var interval: Interval
}

// MARK: CustomDebugStringConvertible
extension TimeSettings: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "TimeSettings(timeRange: \(timeRange), interval: \(interval))"
    }
}

// MARK: computed properties
extension TimeSettings {
    public static var `default`: Self {
        return Self(
            timeRange: TimeRange(
                start: MilitaryTime(hour: 7, minute: 0),
                end: .endOfDay
            ),
            interval: .fullDay
        )
    }
}
