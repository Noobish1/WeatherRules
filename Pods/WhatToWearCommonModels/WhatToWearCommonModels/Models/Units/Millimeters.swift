import Foundation
import Tagged

public enum MillimetersTag {}

public typealias Millimeters<A> = Tagged<MillimetersTag, A>

extension Tagged where Tag == MillimetersTag, RawValue == Double {
    public var measurement: Measurement<UnitLength> {
        return Measurement(value: self.rawValue, unit: .millimeters)
    }
}
