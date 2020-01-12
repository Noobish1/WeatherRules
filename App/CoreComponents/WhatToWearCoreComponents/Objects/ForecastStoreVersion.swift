import Foundation
import WhatToWearCore

// MARK: ForecastStoreVersion
public enum ForecastStoreVersion: String {
    case initial = "initial"
}

// MARK: DefaultsVersionProtocol
extension ForecastStoreVersion: DefaultsVersionProtocol {
    public static let defaultVersion: Self = .initial
}
