import Foundation
import WhatToWearCore
import WhatToWearModels

internal struct MeasurementSystemViewModel: SimpleFiniteSetViewModelProtocol {
    // MARK: properties
    internal let underlyingModel: MeasurementSystem
    internal let shortTitle: String
    
    // MARK: static init helpers
    internal static func shortTitle(for system: MeasurementSystem) -> String {
        switch system {
            case .metric: return NSLocalizedString("Metric", comment: "")
            case .imperial: return NSLocalizedString("Imperial", comment: "")
        }
    }
}
