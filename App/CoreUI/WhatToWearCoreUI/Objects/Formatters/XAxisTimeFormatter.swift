import Foundation
import WhatToWearCharts
import WhatToWearCore

// MARK: XAxisTimeFormatter
internal final class XAxisTimeFormatter {
    // MARK: properties
    private let dateFormatter: DateFormatter
    private let currentTime: Date
    private let calendar: Calendar
    private let day: Date
    private let showNowLabel: Bool

    // MARK: init
    internal init(chartParams: WeatherChartView.Params) {
        let timeZone = chartParams.forecast.forecast.timeZone
        
        self.calendar = Calendars.shared.calendar(for: timeZone)
        self.dateFormatter = DateFormatters.shared.xAxisDateFormatter(for: timeZone)
        self.currentTime = chartParams.currentTime
        self.day = chartParams.day
        self.showNowLabel = chartParams.componentsToShow.contains(.currentTime)
    }

    // MARK: checks
    private func isCurrentTimeWithin60Minutes(of otherTimeInterval: CGFloat) -> Bool {
        // Must be the same day otherwise
        // if the value is 11:30pm the previous day it'll show a "now" label on the previous day also

        let otherDate = Date(timeIntervalSince1970: Double(otherTimeInterval))
        let startOfDayTomorrow = calendar.startOfDay(for: currentTime.addingTimeInterval(24.hours))

        // This guard reads:
        // Ensure that the day we are displaying is the same as the current day and
        // The other date is the same day as the current day or the start of tomorrow
        guard
            calendar.isDate(day, inSameDayAs: currentTime) &&
            (calendar.isDate(otherDate, inSameDayAs: currentTime) || otherDate == startOfDayTomorrow)
        else {
            return false
        }

        let diff = abs(currentTime.timeIntervalSince1970 - Double(otherTimeInterval))

        return diff < 60.minutes
    }
}

// MARK: AxisValueFormatterProtocol
extension XAxisTimeFormatter: AxisValueFormatterProtocol {
    internal func stringForValue(_ value: CGFloat) -> String {
        if showNowLabel && isCurrentTimeWithin60Minutes(of: value) {
            return NSLocalizedString("Now", comment: "")
        } else {
            return dateFormatter.string(from: Date(timeIntervalSince1970: Double(value)))
        }
    }
}

// MARK: AxisColorFormatterProtocol
extension XAxisTimeFormatter: AxisColorFormatterProtocol {
    internal func colorForValue(_ value: CGFloat) -> UIColor {
        if showNowLabel && isCurrentTimeWithin60Minutes(of: value) {
            return .orange
        } else {
            return .white
        }
    }
}
