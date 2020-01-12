import Foundation
import Tagged

public enum RadiansTag {}

public typealias Radians<A> = Tagged<RadiansTag, A>

extension Tagged where Tag == RadiansTag, RawValue == Double {
    public var measurement: Measurement<UnitAngle> {
        return Measurement(value: self.rawValue, unit: .radians)
    }

    public func toDegrees() -> Degrees<RawValue> {
        return Degrees(rawValue: measurement.converted(to: .degrees).value)
    }
}
