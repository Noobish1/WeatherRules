import Foundation

// MARK: Int Extension for TimeInterval
extension Int {
    public var days: TimeInterval {
        return TimeInterval(self).days
    }

    public var hours: TimeInterval {
        return TimeInterval(self).hours
    }

    public var minutes: TimeInterval {
        return TimeInterval(self).minutes
    }

    public var seconds: TimeInterval {
        return TimeInterval(self)
    }
}
