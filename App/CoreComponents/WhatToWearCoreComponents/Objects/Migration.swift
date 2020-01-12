import Foundation
import WhatToWearModels

// MARK: Migration
public struct Migration {
    // MARK: properties
    private let closure: (Data) throws -> Data
    
    // MARK: types of migration
    public static func noMigrationRequired() -> Self {
        return Self(closure: { $0 })
    }

    public static func simple<Left, Right: Migratable>(from: Left.Type, to: Right.Type) -> Self where Right.PreviousObject == Left {
        return Self(closure: SimpleMigration<Left, Right>.migrate)
    }
    
    public static func custom(_ closure: @escaping (Data) throws -> Data) -> Self {
        return Self(closure: closure)
    }
 
    // MARK: performing
    public func perform(from data: Data) throws -> Data {
        return try closure(data)
    }
}
