import Foundation
import WhatToWearCore
import WhatToWearModels

internal struct WindTypeViewModel: ShortLongFiniteSetViewModelProtocol {
    // MARK: properties
    internal let underlyingModel: WindType
    internal let shortTitle: String
    internal let longTitle: String
    
    // MARK: static init helpers
    internal static func shortTitle(for type: WindType) -> String {
        switch type {
            case .gust: return NSLocalizedString("Gust", comment: "")
            case .speed: return NSLocalizedString("Speed", comment: "")
        }
    }
    
    internal static func longTitle(for type: WindType) -> String {
        switch type {
            case .gust: return NSLocalizedString("Wind Gust", comment: "")
            case .speed: return NSLocalizedString("Wind Speed", comment: "")
        }
    }
}
