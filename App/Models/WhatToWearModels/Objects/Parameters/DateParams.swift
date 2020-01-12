import Foundation
import WhatToWearCore

// MARK: DateParams
public struct DateParams: Codable, Hashable {
    // MARK: properties
    internal let day: Int
    internal let month: Int
    internal let year: Int

    // MARK: init
    internal init(day: Int, month: Int, year: Int) {
        self.day = day
        self.month = month
        self.year = year
    }

    public init(date: Date, timeZone: TimeZone) {
        // We want components from the current calendar
        // as the given date is from the current timezone/calendar
        let calendar = Calendars.shared.calendar(for: timeZone)

        self.init(
            day: calendar.component(.day, from: date),
            month: calendar.component(.month, from: date),
            year: calendar.component(.year, from: date)
        )
    }
}

// MARK: Comparable
extension DateParams: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return (lhs.year, lhs.month, lhs.day) < (rhs.year, rhs.month, rhs.day)
    }
}
