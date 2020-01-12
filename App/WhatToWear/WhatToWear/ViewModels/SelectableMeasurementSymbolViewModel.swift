import Foundation
import WhatToWearCore
import WhatToWearModels

internal enum SelectableMeasurementSymbolViewModel {
    internal static func shortTitle(for symbol: SelectableMeasurementSymbol) -> String {
        switch symbol {
            case .equalTo: return NSLocalizedString("=", comment: "")
        }
    }
    
    internal static func longTitle(for symbol: SelectableMeasurementSymbol) -> String {
        switch symbol {
            case .equalTo: return NSLocalizedString("Equal To", comment: "")
        }
    }
}
