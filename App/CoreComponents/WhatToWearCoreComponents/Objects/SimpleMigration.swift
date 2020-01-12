import Foundation
import WhatToWearModels

public enum SimpleMigration<Left, Right: Migratable> where Right.PreviousObject == Left {
    public static func migrate(from data: Data) throws -> Data {
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()

        let old = try decoder.decode(Left.self, from: data)
        let new = Right(previousObject: old)

        return try encoder.encode(new)
    }
}
