import Foundation
import Tagged

public enum KilometersTag {}

public typealias Kilometers<A> = Tagged<KilometersTag, A>

extension Tagged where Tag == KilometersTag, RawValue == Double {
    public var measurement: Measurement<UnitLength> {
        return Measurement(value: self.rawValue, unit: .kilometers)
    }
}
