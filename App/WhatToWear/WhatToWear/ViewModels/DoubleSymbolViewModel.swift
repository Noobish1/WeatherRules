import Foundation
import WhatToWearCore
import WhatToWearModels

internal struct DoubleSymbolViewModel: ShortLongFiniteSetViewModelProtocol {
    // MARK: properties
    internal let underlyingModel: DoubleSymbol
    internal let shortTitle: String
    internal let longTitle: String
    
    // MARK: static init helpers
    internal static func shortTitle(for symbol: DoubleSymbol) -> String {
        switch symbol {
            case .lessThan: return NSLocalizedString("<", comment: "")
            case .lessThanOrEqualTo: return NSLocalizedString("<=", comment: "")
            case .greaterThan: return NSLocalizedString(">", comment: "")
            case .greaterThanOrEqualTo: return NSLocalizedString(">=", comment: "")
            case .equalTo: return NSLocalizedString("=", comment: "")
        }
    }
    
    internal static func longTitle(for symbol: DoubleSymbol) -> String {
        switch symbol {
            case .lessThan: return NSLocalizedString("Less Than", comment: "")
            case .lessThanOrEqualTo: return NSLocalizedString("Less Than Or Equal To", comment: "")
            case .greaterThan: return NSLocalizedString("Greater Than", comment: "")
            case .greaterThanOrEqualTo: return NSLocalizedString("Greater Than or Equal To", comment: "")
            case .equalTo: return NSLocalizedString("Equal To", comment: "")
        }
    }
}
