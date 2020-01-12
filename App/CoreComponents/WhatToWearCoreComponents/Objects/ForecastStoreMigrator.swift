import Foundation

internal final class ForecastStoreMigrator: MigratorProtocol {
    // MARK: typealiases
    internal typealias Object = ForecastStore
    
    // MARK: migration
    internal func migrationToNextVersion(from version: ForecastStoreVersion) -> Migration {
        switch version {
            case .initial: return .noMigrationRequired()
        }
    }
}
