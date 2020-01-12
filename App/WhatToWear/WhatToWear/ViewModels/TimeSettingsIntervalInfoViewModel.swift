import Foundation
import WhatToWearModels

internal struct TimeSettingsIntervalInfoViewModel {
    // MARK: properties
    internal let title: String
    
    // MARK: init
    internal init(interval: TimeSettings.Interval) {
        self.title = Self.title(for: interval)
    }
    
    // MARK: static init helpers
    private static func title(for interval: TimeSettings.Interval) -> String {
        switch interval {
            case .hourly:
                return NSLocalizedString("'Hourly' means that you'll see what hours of the day your rules are met (within your Time Range).", comment: "")
            case .fullDay:
                return NSLocalizedString("'Full Time Range' means you'll see rules which are met for any hour in your Time Range.", comment: "")
        }
    }
}
