import WhatToWearModels

// MARK: DefaultsBackedObject
extension StoredLocations: DefaultsBackedObject {
    public typealias Version = StoredLocationsVersion
}

extension StoredLocations: DefaultsBackedObjectWithNilDefault {}
