import Foundation

public struct AnyMigrator<Object: DefaultsBackedObject>: MigratorProtocol {
    // MARK: properties
    public let migrationToNextVersionClosure: (Object.Version) -> Migration
    
    // MARK: init
    public init<M: MigratorProtocol>(_ migrator: M) where M.Object == Object {
        self.migrationToNextVersionClosure = migrator.migrationToNextVersion
    }
    
    // MARK: migration
    public func migrationToNextVersion(from version: Object.Version) -> Migration {
        return migrationToNextVersionClosure(version)
    }
}
