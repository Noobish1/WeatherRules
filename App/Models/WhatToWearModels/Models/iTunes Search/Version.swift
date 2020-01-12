import Foundation
import Tagged

public enum VersionTag {}

public typealias Version<A> = Tagged<VersionTag, A>

extension Tagged where Tag == VersionTag, RawValue == String {
    public var object: OperatingSystemVersion {
        return OperatingSystemVersion.from(string: rawValue)
    }
}
