import Foundation
import Tagged

public enum PercentageTag {}

public typealias Percentage<A> = Tagged<PercentageTag, A>

extension Int {
    public var percent: Percentage<CGFloat> {
        return Percentage(rawValue: CGFloat(self) / 100)
    }
}
