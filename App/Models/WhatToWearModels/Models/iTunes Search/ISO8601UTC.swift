import Foundation
import Tagged
import WhatToWearCore

public enum ISO8601UTCTag {}

public typealias ISO8601UTC<A> = Tagged<ISO8601UTCTag, A>

extension Tagged where Tag == ISO8601UTCTag, RawValue == String {
    public var date: Date {
        // We use current timeZone because we are comparing against device timezone
        let formatter = DateFormatters.shared.appleReleaseDateFormatter(for: .current)

        guard let date = formatter.date(from: rawValue) else {
            fatalError("Could not convert \(rawValue) to a Date")
        }

        return date
    }
}
