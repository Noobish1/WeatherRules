import Foundation
import WhatToWearCommonModels
import WhatToWearCore
import WhatToWearModels

internal struct DayOfWeekViewModel: ShortLongFiniteSetViewModelProtocol {
    // MARK: properties
    internal let underlyingModel: DayOfWeek
    internal let shortTitle: String
    internal let longTitle: String
    
    // MARK: static init helpers
    internal static func shortTitle(for value: DayOfWeek) -> String {
        switch value {
            case .monday: return NSLocalizedString("Monday", comment: "")
            case .tuesday: return NSLocalizedString("Tuesday", comment: "")
            case .wednesday: return NSLocalizedString("Wednesday", comment: "")
            case .thursday: return NSLocalizedString("Thursday", comment: "")
            case .friday: return NSLocalizedString("Friday", comment: "")
            case .saturday: return NSLocalizedString("Saturday", comment: "")
            case .sunday: return NSLocalizedString("Sunday", comment: "")
        }
    }
    
    internal static func longTitle(for value: DayOfWeek) -> String {
        return shortTitle(for: value)
    }
}
