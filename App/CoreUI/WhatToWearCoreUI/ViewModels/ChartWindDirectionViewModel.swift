import Foundation
import WhatToWearCommonModels
import WhatToWearModels

internal struct ChartWindDirectionViewModel {
    // MARK: properties
    internal let arrowString: String
    
    // MARK: init
    internal init?(windBearing: Double?) {
        guard let windDirection = WindDirection(windBearing: windBearing) else {
            return nil
        }
        
        self.arrowString = Self.arrowString(for: windDirection)
    }
    
    // MARK: static init helpers
    internal static func arrowString(for windDirection: WindDirection) -> String {
        switch windDirection {
            case .north: return "↑"
            case .south: return "↓"
            case .east: return "→"
            case .west: return "←"
            case .northEast: return "↗"
            case .northWest: return "↖"
            case .southEast: return "↘"
            case .southWest: return "↙"
        }
    }
}
