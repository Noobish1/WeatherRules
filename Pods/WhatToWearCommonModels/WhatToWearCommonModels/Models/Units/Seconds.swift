import Foundation
import Tagged

public enum SecondsTag {}

public typealias Seconds<A> = Tagged<SecondsTag, A>

extension Tagged where Tag == SecondsTag, RawValue: BinaryFloatingPoint {
    public var timeInterval: TimeInterval {
        return TimeInterval(self.rawValue)
    }

    public var date: Date {
        return Date(timeIntervalSince1970: self.timeInterval)
    }
}
