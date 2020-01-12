import Foundation
import Tagged

public enum HectopascalsTag {}

public typealias Hectopascals<A> = Tagged<HectopascalsTag, A>

extension Tagged where Tag == HectopascalsTag, RawValue == Double {
    public var measurement: Measurement<UnitPressure> {
        return Measurement(value: self.rawValue, unit: .hectopascals)
    }
}
