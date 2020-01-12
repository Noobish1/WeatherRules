import Foundation
import WhatToWearCore
import WhatToWearModels

internal struct TimeSymbolViewModel: ShortLongFiniteSetViewModelProtocol {
    // MARK: properties
    internal let underlyingModel: TimeSymbol
    internal let shortTitle: String
    internal let longTitle: String
    
    // MARK: static init helpers
    internal static func shortTitle(for symbol: TimeSymbol) -> String {
        return longTitle(for: symbol)
    }
    
    internal static func longTitle(for symbol: TimeSymbol) -> String {
        switch symbol {
            case .between: return NSLocalizedString("Between", comment: "")
            case .before: return NSLocalizedString("Before", comment: "")
            case .after: return NSLocalizedString("After", comment: "")
        }
    }
}
