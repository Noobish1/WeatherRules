import Foundation
import Tagged

public enum MetersPerSecondTag {}

public typealias MetersPerSecond<A> = Tagged<MetersPerSecondTag, A>

extension Tagged where Tag == MetersPerSecondTag, RawValue == Double {
    public var measurement: Measurement<UnitSpeed> {
        return Measurement(value: self.rawValue, unit: .metersPerSecond)
    }
}
