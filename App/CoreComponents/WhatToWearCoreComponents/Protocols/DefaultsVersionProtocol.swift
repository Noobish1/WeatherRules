import Foundation
import WhatToWearCore

// MARK: DefaultsVersionProtocol
public protocol DefaultsVersionProtocol: RawRepresentable, NonEmptyCaseIterable, Equatable {
    // used when retrieving a version and none is found
    static var defaultVersion: Self { get }
}

// MARK: Extensions
extension DefaultsVersionProtocol {
    public static var latest: Self {
        return nonEmptyCases.last
    }
}
