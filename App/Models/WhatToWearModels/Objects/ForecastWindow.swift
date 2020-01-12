import Foundation
import WhatToWearCore

public struct ForecastWindow {
    // MARK: Distance
    public enum Distance: Int {
        case inThePast = -13
        case inTheFuture = 7
    }

    // MARK: properties
    internal let start: DateParams
    internal let end: DateParams

    // MARK: creating windows
    public static func around(date: Date, timeZone: TimeZone) -> Self {
        let calendar = Calendars.shared.calendar(for: timeZone)

        guard
            let start = calendar.date(byAdding: .day, value: Distance.inThePast.rawValue, to: date)
        else {
            fatalError("Could not create date by adding \(Distance.inThePast) days to \(date)")
        }

        guard
            let end = calendar.date(byAdding: .day, value: Distance.inTheFuture.rawValue, to: date)
        else {
            fatalError("Could not create date by adding \(Distance.inTheFuture) days to \(date)")
        }

        return Self(
            start: DateParams(date: start, timeZone: timeZone),
            end: DateParams(date: end, timeZone: timeZone)
        )
    }

    // MARK: checks
    public func contains(dateParams: DateParams) -> Bool {
        return dateParams > start && dateParams < end
    }
}
