import Foundation

// MARK: DefaultsBackedControllerCommon
public protocol DefaultsBackedControllerCommon: AnyObject {
    associatedtype Object: DefaultsBackedObject
    
    var config: ControllerConfig { get }
    var migrator: AnyMigrator<Object> { get }
}

// MARK: General extensions
extension DefaultsBackedControllerCommon {
    // MARK: static retrieving
    public static func retrieveVersion(config: ControllerConfig) -> Object.Version {
        if let rawVersion = config.defaults.string(forKey: config.objectVersionKey) {
            if let version = Object.Version(rawValue: rawVersion) {
                return version
            } else {
                fatalError("\(rawVersion) is not a valid \(self)")
            }
        } else {
            return Object.Version.defaultVersion
        }
    }
    
    // MARK: static saving
    public static func save(version: Object.Version, config: ControllerConfig) {
        config.defaults.set(version.rawValue, forKey: config.objectVersionKey)
    }
    
    // MARK: static saving
    @discardableResult
    internal static func saveWithoutSideEffects(_ object: Object, config: ControllerConfig) -> Object {
        do {
            let data = try JSONEncoder().encode(object)
            
            config.defaults.set(data, forKey: config.objectKey)
            
            save(version: .latest, config: config)
            
            return object
        } catch let error {
            // If this fails then something is serious wrong
            fatalError("Encoding \(Object.self) \(object) failed with error \(error)")
        }
    }
    
    // MARK: static removing
    public static func removeObjectWithoutSideEffects(config: ControllerConfig) {
        config.defaults.removeObject(forKey: config.objectKey)
        config.defaults.removeObject(forKey: config.objectVersionKey)
    }

    // MARK: instance removing
    public func removeObject() {
        Self.removeObjectWithoutSideEffects(config: config)
    }
}
