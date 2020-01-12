import Foundation
import Tagged

public enum CentimetersTag {}

public typealias Centimeters<A> = Tagged<CentimetersTag, A>

extension Tagged where Tag == CentimetersTag, RawValue == Double {
    public var measurement: Measurement<UnitLength> {
        return Measurement(value: self.rawValue, unit: .centimeters)
    }
}
