import Foundation
import WhatToWearModels

// MARK: DefaultsBackedObject
extension GlobalSettings: DefaultsBackedObject {
    public typealias Version = GlobalSettingsVersion
}

// MARK: DefaultsBackedObjectWithNonNilDefault
extension GlobalSettings: DefaultsBackedObjectWithNonNilDefault {}
