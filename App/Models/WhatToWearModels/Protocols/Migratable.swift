import Foundation

public protocol Migratable: Codable {
    associatedtype PreviousObject: Codable

    init(previousObject: PreviousObject)
}
