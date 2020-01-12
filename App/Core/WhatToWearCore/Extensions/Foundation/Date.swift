import Foundation

// MARK: General extensions
extension Date {
    public static var now: Date {
        return Date()
    }

    public func isInSameDay(as date: Date, using calendar: Calendar) -> Bool {
        return calendar.isDate(self, inSameDayAs: date)
    }
}
