import Foundation
import WhatToWearCore
import WhatToWearModels

// MARK: RulesVersion
public enum StoredRulesVersion: String {
    case preVersions = "preVersions"
    case initial = "initial"
}

// MARK: DefaultsVersionProtocol
extension StoredRulesVersion: DefaultsVersionProtocol {
    public static let defaultVersion: Self = .preVersions
}
