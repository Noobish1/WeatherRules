import Foundation
import WhatToWearCommonModels
import WhatToWearCore

// MARK: WindType
public enum WindType: String, FiniteSetValueProtocol {
    case gust = "gust"
    case speed = "speed"
}

// MARK: Extensions
extension WindType {
    public var dataPointKeyPath: KeyPath<HourlyDataPoint, Measurement<UnitSpeed>?> {
        switch self {
            case .gust: return \.windGust
            case .speed: return \.windSpeed
        }
    }
}
