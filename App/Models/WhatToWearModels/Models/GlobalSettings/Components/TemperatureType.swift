import Foundation
import WhatToWearCommonModels
import WhatToWearCore

// MARK: TemperatureType
public enum TemperatureType: String, FiniteSetValueProtocol {
    case apparent = "apparent"
    case air = "air"
}

// MARK: Extensions
extension TemperatureType {
    public var dataPointKeyPath: KeyPath<HourlyDataPoint, Measurement<UnitTemperature>> {
        switch self {
            case .apparent: return \.apparentTemperature
            case .air: return \.temperature
        }
    }
}
