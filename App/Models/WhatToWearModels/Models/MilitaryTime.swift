import Foundation
import WhatToWearCore

// MARK: MilitaryTime
public struct MilitaryTime: Codable, Equatable {
    // MARK: static properties
    public static let startOfDay = Self(hour: 0, minute: 0)
    public static let endOfDay = Self(hour: 23, minute: 59)

    // MARK: properties
    public let hour: Int
    public let minute: Int

    // MARK: init
    public init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
    }
}

// MARK: other inits
extension MilitaryTime {
    public init(date: Date, calendar: Calendar) {
        self.hour = calendar.component(.hour, from: date)
        self.minute = calendar.component(.minute, from: date)
    }
}

// MARK: computed properties
extension MilitaryTime {
    public var components: DateComponents {
        return DateComponents(hour: hour, minute: minute)
    }
}

// MARK: differences
extension MilitaryTime {
    public func minutesSince(_ otherTime: Self) -> Int {
        let ourTotalMinutes = (self.hour * 60) + self.minute
        let theirTotalMinutes = (otherTime.hour * 60) + otherTime.minute

        return ourTotalMinutes - theirTotalMinutes
    }
}

// MARK: Comparable
extension MilitaryTime: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.hour < rhs.hour {
            return true
        } else {
            return lhs.minute < rhs.minute
        }
    }
}
