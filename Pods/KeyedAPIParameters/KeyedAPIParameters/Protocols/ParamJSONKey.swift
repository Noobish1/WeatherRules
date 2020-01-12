import Foundation

public protocol ParamJSONKey: RawRepresentable, Hashable {
    var stringValue: String { get }
}

extension ParamJSONKey where RawValue == String {
    public var stringValue: String {
        return rawValue
    }
}
