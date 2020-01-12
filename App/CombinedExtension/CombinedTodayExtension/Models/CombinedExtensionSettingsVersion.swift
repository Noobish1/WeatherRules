import Foundation
import WhatToWearCoreComponents

// MARK: CombinedExtensionSettingsVersion
internal enum CombinedExtensionSettingsVersion: String {
    case initial = "initial"
}

// MARK: DefaultsVersionProtocol
extension CombinedExtensionSettingsVersion: DefaultsVersionProtocol {
    public static let defaultVersion: Self = .initial
}
