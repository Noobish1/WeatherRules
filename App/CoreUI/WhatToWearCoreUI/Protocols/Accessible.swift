import Foundation

public protocol Accessible: AnyObject {
    associatedtype AccessibilityIdentifiers: AccessibilityIdentifiersProtocol where AccessibilityIdentifiers.EnclosingType == Self
}
