import Foundation
import WhatToWearCore
import WhatToWearCoreComponents
import WhatToWearExtensionCore

// MARK: CombinedExtensionSettings
internal struct CombinedExtensionSettings: Codable, Equatable, Withable {
    // MARK: properties
    internal var displayMode: CombinedExtensionDisplayMode
}

// MARK: DefaultsBackedObject
extension CombinedExtensionSettings: DefaultsBackedObject {
    // MARK: typealiases
    internal typealias Version = CombinedExtensionSettingsVersion
}

// MARK: DefaultsBackedObjectWithNonNilDefault
extension CombinedExtensionSettings: DefaultsBackedObjectWithNonNilDefault {
    internal static var `default`: Self {
        return CombinedExtensionSettings(displayMode: .forecast)
    }
}
