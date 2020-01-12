import Foundation

internal struct CustomEvent {
    // MARK: properties
    internal let name: String
    internal let customAttributes: [String: String]

    // MARK: init
    internal init(name: String, customAttributes: [String: String] = [:]) {
        self.name = name
        self.customAttributes = customAttributes
    }
}
