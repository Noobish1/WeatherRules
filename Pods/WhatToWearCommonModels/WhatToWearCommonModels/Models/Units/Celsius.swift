import Foundation
import Tagged

public enum CelsiusTag {}

public typealias Celsius<A> = Tagged<CelsiusTag, A>

extension Tagged where Tag == CelsiusTag, RawValue == Double {
    public var measurement: Measurement<UnitTemperature> {
        return Measurement(value: self.rawValue, unit: .celsius)
    }
}
