import Foundation

public protocol DefaultsBackedObjectWithNilDefault: DefaultsBackedObject {}

public protocol DefaultsBackedControllerWithOptionalObject: DefaultsBackedControllerCommon where Object: DefaultsBackedObjectWithNilDefault {}

extension DefaultsBackedControllerWithOptionalObject {
    // MARK: static retrieving
    public static func retrieve(config: ControllerConfig, migrator: AnyMigrator<Object>) -> Object? {
        switch retrieveWithResult(config: config, migrator: migrator) {
            case .success(let object):
                return object
            case .failure(let retrieveError):
                switch retrieveError {
                    case .migration(fromVersion: let version, error: let migrationError):
                        // We fatal error here because:
                        // It doesn't lead to data loss,
                        // users hopefully will try to update the app and logs
                        fatalError("Migrating data from version \(version) failed with error \(migrationError)")
                    case .decoding(let decodingError):
                        // We fatal error here because:
                        // It doesn't lead to data loss,
                        // users hopefully will try to update the app and logs
                        fatalError("Decoding \(Object.self) failed with error \(decodingError)")
                }
        }
    }
    
    public static func retrieveWithResult(config: ControllerConfig, migrator: AnyMigrator<Object>) -> Result<Object?, RetrievalError<Object>> {
        guard let savedData = config.defaults.data(forKey: config.objectKey) else {
            return .success(nil)
        }
        
        let version = retrieveVersion(config: config)
        
        do {
            let endData = try migrator.migrate(data: savedData, from: version)
            
            do {
                let object = try JSONDecoder().decode(Object.self, from: endData)
                
                saveWithoutSideEffects(object, config: config)
                
                return .success(object)
            } catch let error {
                return .failure(.decoding(error))
            }
        } catch let error {
            return .failure(.migration(fromVersion: version, error: error))
        }
    }
    
    @discardableResult
    public static func save(_ object: Object?, config: ControllerConfig) -> Object? {
        if let object = object {
            return saveWithoutSideEffects(object, config: config)
        } else {
            removeObjectWithoutSideEffects(config: config)
            
            return nil
        }
    }
    
    // MARK: instance retrieving
    public func retrieve() -> Object? {
        return Self.retrieve(config: config, migrator: migrator)
    }
    
    public func retrieveWithResult() -> Result<Object?, RetrievalError<Object>> {
        return Self.retrieveWithResult(config: config, migrator: migrator)
    }
}
