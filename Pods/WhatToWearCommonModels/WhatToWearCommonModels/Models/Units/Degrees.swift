import Foundation
import Tagged

public enum DegreesTag {}

public typealias Degrees<A> = Tagged<DegreesTag, A>

extension Tagged where Tag == DegreesTag, RawValue == Double {
    public var measurement: Measurement<UnitAngle> {
        return Measurement(value: self.rawValue, unit: .degrees)
    }

    public func toRadians() -> Radians<RawValue> {
        return Radians(rawValue: measurement.converted(to: .radians).value)
    }
}
