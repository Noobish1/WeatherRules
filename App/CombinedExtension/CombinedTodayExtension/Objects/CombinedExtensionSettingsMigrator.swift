import Foundation
import WhatToWearCoreComponents

internal final class CombinedExtensionSettingsMigrator: MigratorProtocol {
    // MARK: typealiases
    internal typealias Object = CombinedExtensionSettings
    
    // MARK: migration
    internal func migrationToNextVersion(from version: CombinedExtensionSettingsVersion) -> Migration {
        switch version {
            case .initial: return .noMigrationRequired()
        }
    }
}
