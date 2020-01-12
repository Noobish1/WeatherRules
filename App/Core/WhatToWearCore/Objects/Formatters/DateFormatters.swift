import Foundation
import Then

public final class DateFormatters: Singleton {
    // MARK: static properties
    public static let shared = DateFormatters()

    // MARK: instance properties
    internal private(set) var appleReleaseDateFormatters: [TimeZone: ISO8601DateFormatter] = [:]
    internal private(set) var xAxisDateFormatters: [TimeZone: DateFormatter] = [:]
    internal private(set) var hourWithSpaceFormatters: [TimeZone: DateFormatter] = [:]
    internal private(set) var dayFormatters: [TimeZone: DateFormatter] = [:]

    // MARK: init
    private init() {}

    // MARK: ISO8601
    public func appleReleaseDateFormatter(for timeZone: TimeZone) -> ISO8601DateFormatter {
        // Example: 2019-02-26T01:46:22Z
        return appleReleaseDateFormatters.value(
            forKey: timeZone,
            orInsertAndReturn: ISO8601DateFormatter().then {
                $0.formatOptions = [
                    .withFullDate, .withFullTime, .withColonSeparatorInTime, .withDashSeparatorInDate
                ]
                $0.timeZone = timeZone
            }
        )
    }

    // MARK: xAxisDateFormatter
    public func xAxisDateFormatter(for timeZone: TimeZone) -> DateFormatter {
        return xAxisDateFormatters.value(forKey: timeZone, orInsertAndReturn: DateFormatter().then {
            $0.dateFormat = "ha"
            $0.timeZone = timeZone
        })
    }

    // MARK: hourWithSpaceFormatter
    public func hourWithSpaceFormatter(for timeZone: TimeZone) -> DateFormatter {
        return hourWithSpaceFormatters.value(forKey: timeZone, orInsertAndReturn: DateFormatter().then {
            $0.dateFormat = "h\(String.nbsp)a"
            $0.timeZone = timeZone
        })
    }

    // MARK: dayFormatter
    public func dayFormatter(for timeZone: TimeZone) -> DateFormatter {
        return dayFormatters.value(forKey: timeZone, orInsertAndReturn: DateFormatter().then {
            $0.dateFormat = "EEEE, MMM d"
            $0.timeZone = timeZone
        })
    }
}
