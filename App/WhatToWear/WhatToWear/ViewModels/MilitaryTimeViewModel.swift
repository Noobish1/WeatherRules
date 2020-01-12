import Foundation
import WhatToWearCore
import WhatToWearModels

internal struct MilitaryTimeViewModel {
    // MARK: properties
    internal let time: MilitaryTime
    internal let displayedString: String

    // MARK: init
    internal init(time: MilitaryTime, timeZone: TimeZone) {
        self.time = time
        self.displayedString = Self.displayedString(for: time, timeZone: timeZone)
    }
    
    // MARK: static init helpers
    internal static func displayedString(for time: MilitaryTime, timeZone: TimeZone) -> String {
        let formatter = DateFormatters.shared.hourWithSpaceFormatter(for: timeZone)
        let calendar = Calendars.shared.calendar(for: timeZone)

        if time == .endOfDay {
            return NSLocalizedString("Midnight", comment: "")
        } else {
            guard let date = calendar.date(from: time.components) else {
                fatalError("Cannot create date from \(time.components)")
            }

            return formatter.string(from: date)
        }
    }
}
