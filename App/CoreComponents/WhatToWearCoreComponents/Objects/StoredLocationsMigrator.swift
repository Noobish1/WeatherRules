import Foundation
import WhatToWearModels

internal final class StoredLocationsMigrator: MigratorProtocol {
    // MARK: typealiases
    internal typealias Object = StoredLocations
    
    // MARK: migrations
    internal func migrationToNextVersion(from version: StoredLocationsVersion) -> Migration {
        switch version {
            case .beforeStoredLocations:
                return .simple(from: ValidLocation.self, to: StoredLocations.self)
            case .initial:
                return .noMigrationRequired()
        }
    }
}
