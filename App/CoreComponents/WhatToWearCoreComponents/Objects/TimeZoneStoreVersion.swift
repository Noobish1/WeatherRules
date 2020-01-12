import Foundation
import WhatToWearCore

// MARK: TimeZoneStoreVersion
public enum TimeZoneStoreVersion: String {
    case initial = "initial"
}

// MARK: DefaultsVersionProtocol
extension TimeZoneStoreVersion: DefaultsVersionProtocol {
    public static let defaultVersion: Self = .initial
}
