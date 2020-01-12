import Foundation
import WhatToWearCore
import WhatToWearModels

// MARK: TimeSettingsVersion
public enum TimeSettingsVersion: String {
    case initial = "initial"
}

// MARK: DefaultsVersionProtocol
extension TimeSettingsVersion: DefaultsVersionProtocol {
    public static let defaultVersion: Self = .initial
}
