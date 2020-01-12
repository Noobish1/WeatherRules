import Foundation
import WhatToWearCore
import WhatToWearModels

// MARK: GlobalSettingsVersion
public enum GlobalSettingsVersion: String {
    case initial = "initial"
    case rulesSetToRulesDict = "rulesSetToRulesDict"
    case addedBackgrounds = "addedBackgrounds"
    case addedUpdates = "addedUpdates"
    case addedWhatsNew = "addedWhatsNew"
    case addedExtraConfig = "addedExtraConfig"
}

// MARK: DefaultsVersionProtocol
extension GlobalSettingsVersion: DefaultsVersionProtocol {
    public static let defaultVersion: Self = .initial
}
