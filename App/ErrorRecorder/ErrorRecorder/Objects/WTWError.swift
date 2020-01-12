import Foundation
import WhatToWearCore

public struct WTWError {
    // MARK: properties
    internal let formatMD5: String
    internal let failureReason: String

    // MARK: init
    public init(format: String, arguments: [CVarArg]) {
        let failureReason = String(format: format, arguments: arguments)

        self.formatMD5 = format.md5HexString()
        self.failureReason = failureReason
    }
}
