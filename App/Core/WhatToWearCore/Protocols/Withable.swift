import Foundation

// MARK: Withable
public protocol Withable {}

// MARK: Extensions
extension Withable {
    public func with<V>(_ keyPath: WritableKeyPath<Self, V>, value: V) -> Self {
        var us = self

        us[keyPath: keyPath] = value

        return us
    }
}
