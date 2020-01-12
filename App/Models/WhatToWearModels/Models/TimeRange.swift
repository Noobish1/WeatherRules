import Foundation
import WhatToWearCore

// MARK: TimeRange
public struct TimeRange: Codable, Equatable {
    public let start: MilitaryTime
    public let end: MilitaryTime

    public init(start: MilitaryTime, end: MilitaryTime) {
        self.start = start
        self.end = end
    }
}

// MARK: computed properties
extension TimeRange {
    public static var allDay: Self {
        return Self(start: .startOfDay, end: .endOfDay)
    }
}

// MARK: helper functions
extension TimeRange {
    public func contains(date: Date, calendar: Calendar) -> Bool {
        let time = MilitaryTime(date: date, calendar: calendar)

        return time >= start && time < end
    }
}

// MARK: with methods
extension TimeRange {
    public func with(start: MilitaryTime, validate: Bool) -> Self {
        if validate && start > self.end {
            return Self(start: start, end: start)
        } else {
            return Self(start: start, end: self.end)
        }
    }

    public func with(end: MilitaryTime, validate: Bool) -> Self {
        if validate && end < self.start {
            return Self(start: end, end: end)
        } else {
            return Self(start: self.start, end: end)
        }
    }
}
