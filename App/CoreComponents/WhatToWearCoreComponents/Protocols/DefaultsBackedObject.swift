import Foundation

public protocol DefaultsBackedObject: Codable {
    associatedtype Version: DefaultsVersionProtocol where Version.RawValue == String
}
