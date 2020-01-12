import Foundation
import WhatToWearModels

// MARK: DefaultsBackedObject
extension StoredRules: DefaultsBackedObject {
    public typealias Version = StoredRulesVersion
}

// MARK: DefaultsBackedObjectWithNonNilDefault
extension StoredRules: DefaultsBackedObjectWithNonNilDefault {}
