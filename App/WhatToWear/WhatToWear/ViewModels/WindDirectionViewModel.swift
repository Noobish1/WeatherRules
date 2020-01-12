import Foundation
import WhatToWearCommonModels
import WhatToWearCore
import WhatToWearModels

internal struct WindDirectionViewModel: ShortLongFiniteSetViewModelProtocol {
    // MARK: properties
    internal let underlyingModel: WindDirection
    internal let shortTitle: String
    internal let longTitle: String
    
    // MARK: static init helpers
    internal static func shortTitle(for value: WindDirection) -> String {
        switch value {
            case .north: return NSLocalizedString("North", comment: "")
            case .south: return NSLocalizedString("South", comment: "")
            case .east: return NSLocalizedString("East", comment: "")
            case .west: return NSLocalizedString("West", comment: "")
            case .northEast: return NSLocalizedString("North East", comment: "")
            case .northWest: return NSLocalizedString("North West", comment: "")
            case .southEast: return NSLocalizedString("South East", comment: "")
            case .southWest: return NSLocalizedString("South West", comment: "")
        }
    }
    
    internal static func longTitle(for value: WindDirection) -> String {
        return shortTitle(for: value)
    }
}
