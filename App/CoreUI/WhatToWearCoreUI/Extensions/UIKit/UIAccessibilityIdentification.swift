import Foundation

extension UIAccessibilityIdentification {
    public func wtw_setAccessibilityIdentifier<T: AccessibilityIdentifiersProtocol>(_ identifier: T) {
        self.accessibilityIdentifier = identifier.stringValue
    }
}
