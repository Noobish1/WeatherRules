import Foundation
import WhatToWearCore

public enum ForecastType {
    case present
    case past
    case future

    // MARK: computed properties
    public var cacheInterval: TimeInterval {
        switch self {
            case .present: return 60.minutes
            case .past: return 30.days
            case .future: return 6.hours
        }
    }

    // MARK: init
    internal init(date: Date, timeZone: TimeZone) {
        let calendar = Calendars.shared.calendar(for: timeZone)
        let today = Date.now

        if calendar.isDate(date, inSameDayAs: today) {
            self = .present
        } else if date < today {
            self = .past
        } else {
            self = .future
        }
    }
}
