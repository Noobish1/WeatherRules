import Foundation

// MARK: MigratorProtocol
public protocol MigratorProtocol {
    associatedtype Object: DefaultsBackedObject
    
    func migrationToNextVersion(from version: Object.Version) -> Migration
}

// MARK: Extensions
extension MigratorProtocol {
    public func migrate(data: Data, from: Object.Version) throws -> Data {
        let versions = Object.Version.allCases

        // swiftlint:disable force_unwrapping
        let fromIndex = versions.firstIndex(of: from)!
        // swiftlint:enable force_unwrapping

        let neededMigrations = versions[fromIndex...].map { migrationToNextVersion(from: $0) }

        return try neededMigrations.reduce(data) { data, migration in
            try migration.perform(from: data)
        }
    }
}
