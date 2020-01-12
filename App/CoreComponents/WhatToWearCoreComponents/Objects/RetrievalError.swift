import Foundation

// MARK: RetrievalError
public enum RetrievalError<Object: DefaultsBackedObject>: Error {
    case migration(fromVersion: Object.Version, error: Error)
    case decoding(Error)
}
