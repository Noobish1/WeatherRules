import Foundation

internal final class TimeZoneStoreMigrator: MigratorProtocol {
    // MARK: typealiases
    internal typealias Object = TimeZoneStore
    
    // MARK: migration
    internal func migrationToNextVersion(from version: TimeZoneStoreVersion) -> Migration {
        switch version {
            case .initial: return .noMigrationRequired()
        }
    }
}
