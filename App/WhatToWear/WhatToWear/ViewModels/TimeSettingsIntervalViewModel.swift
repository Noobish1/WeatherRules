import Foundation
import WhatToWearCore
import WhatToWearModels

internal struct TimeSettingsIntervalViewModel: SimpleFiniteSetViewModelProtocol {
    // MARK: properties
    internal let underlyingModel: TimeSettings.Interval
    internal let shortTitle: String
    
    // MARK: static init helpers
    internal static func shortTitle(for interval: TimeSettings.Interval) -> String {
        switch interval {
            case .hourly: return NSLocalizedString("Hourly", comment: "")
            case .fullDay: return NSLocalizedString("Full Range", comment: "")
        }
    }
}
