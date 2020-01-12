import Foundation
import Tagged

public enum AbsoluteURLTag {}

public typealias AbsoluteURL<A> = Tagged<AbsoluteURLTag, A>

extension Tagged where Tag == AbsoluteURLTag, RawValue == String {
    public var url: URL {
        guard let url = URL(string: rawValue) else {
            fatalError("Could not create a URL from urlString \(rawValue)")
        }

        return url
    }
}
