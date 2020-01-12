import Foundation
import Then

public final class Calendars: Singleton {
    // MARK: static properties
    public static let shared = Calendars()

    // MARK: instance properties
    internal private(set) var calendars: [TimeZone: Calendar] = [:]

    // MARK: init
    private init() {}

    // MARK: calendars
    public func calendar(for timeZone: TimeZone) -> Calendar {
        return calendars.value(
            forKey: timeZone,
            orInsertAndReturn: Calendar.current.with {
                $0.timeZone = timeZone
            }
        )
    }
}
