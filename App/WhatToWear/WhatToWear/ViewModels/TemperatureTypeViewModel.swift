import Foundation
import WhatToWearCore
import WhatToWearModels

internal struct TemperatureTypeViewModel: ShortLongFiniteSetViewModelProtocol {
    // MARK: properties
    internal let underlyingModel: TemperatureType
    internal let shortTitle: String
    internal let longTitle: String
    
    // MARK: static init helpers
    internal static func shortTitle(for type: TemperatureType) -> String {
        switch type {
            case .apparent: return NSLocalizedString("Apparent", comment: "")
            case .air: return NSLocalizedString("Air", comment: "")
        }
    }
    
    internal static func longTitle(for type: TemperatureType) -> String {
        switch type {
            case .apparent: return NSLocalizedString("Apparent Temperature", comment: "")
            case .air: return NSLocalizedString("Air Temperature", comment: "")
        }
    }
}
