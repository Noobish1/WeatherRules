import Foundation
import WhatToWearModels

internal final class TimeSettingsMigrator: MigratorProtocol {
    // MARK: typealiases
    internal typealias Object = TimeSettings
    
    // MARK: migration
    internal func migrationToNextVersion(from version: Object.Version) -> Migration {
        switch version {
            case .initial: return .noMigrationRequired()
        }
    }
}
