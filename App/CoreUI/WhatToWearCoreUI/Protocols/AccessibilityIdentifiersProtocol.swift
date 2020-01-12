import Foundation

public protocol AccessibilityIdentifiersProtocol: RawRepresentable where RawValue == String {
    associatedtype EnclosingType: Accessible
}

extension AccessibilityIdentifiersProtocol {
    public var stringValue: String {
        return "\(EnclosingType.self).\(rawValue)"
    }
}
