import Foundation
import WhatToWearCommonModels
import WhatToWearCore
import WhatToWearModels

internal struct PrecipitationTypeViewModel: ShortLongFiniteSetViewModelProtocol {
    // MARK: properties
    internal let underlyingModel: PrecipitationType
    internal let shortTitle: String
    internal let longTitle: String
    
    // MARK: static init helpers
    internal static func shortTitle(for value: PrecipitationType) -> String {
        switch value {
            case .rain: return NSLocalizedString("Rain", comment: "")
            case .snow: return NSLocalizedString("Snow", comment: "")
            case .sleet: return NSLocalizedString("Sleet", comment: "")
        }
    }
    
    internal static func longTitle(for value: PrecipitationType) -> String {
        return shortTitle(for: value)
    }
}
