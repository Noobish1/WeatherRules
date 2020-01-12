import Foundation

// MARK: TimeInterval extensions
extension TimeInterval {
    public var days: TimeInterval {
        return self * 24.hours
    }

    public var hours: TimeInterval {
        return self * 60.minutes
    }

    public var minutes: TimeInterval {
        return self * 60
    }

    public var seconds: TimeInterval {
        return self
    }

    public var fromNow: DispatchTime {
        return .now() + self
    }
}
