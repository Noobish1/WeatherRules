import Foundation
import WhatToWearCommonCore

// MARK: NonEmptyCaseIterable
public protocol NonEmptyCaseIterable: CaseIterable {
    static var nonEmptyCases: NonEmptyArray<Self> { get }
}

// MARK: General Extensions
extension NonEmptyCaseIterable {
    public static var nonEmptyCases: NonEmptyArray<Self> {
        // swiftlint:disable force_unwrapping
        return NonEmptyArray<Self>(array: Array(self.allCases))!
        // swiftlint:enable force_unwrapping
    }
}
