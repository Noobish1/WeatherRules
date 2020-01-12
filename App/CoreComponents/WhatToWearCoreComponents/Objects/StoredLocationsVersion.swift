import Foundation
import WhatToWearModels

// MARK: StoredLocationsVersion
public enum StoredLocationsVersion: String {
    case beforeStoredLocations = "beforeStoredLocations"
    case initial = "initial"
}

// MARK: DefaultsVersionProtocol
extension StoredLocationsVersion: DefaultsVersionProtocol {
    public static let defaultVersion: Self = .beforeStoredLocations
}
