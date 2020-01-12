import Foundation
import WhatToWearModels

// MARK: DefaultsBackedObject
extension TimeSettings: DefaultsBackedObject {
    public typealias Version = TimeSettingsVersion
}

// MARK: DefaultsBackedObjectWithNonNilDefault
extension TimeSettings: DefaultsBackedObjectWithNonNilDefault {}
