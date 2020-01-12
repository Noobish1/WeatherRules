import Foundation
import WhatToWearCommonCore
import WhatToWearCore

// MARK: MeasurementSystem
public enum MeasurementSystem: String, FiniteSetValueProtocol {
    case metric = "metric"
    case imperial = "imperial"
}

// MARK: Displayed units
extension MeasurementSystem {
    public var displayedUnitForSpeedMeasurement: UnitSpeed {
        switch self {
            case .metric: return .kilometersPerHour
            case .imperial: return .milesPerHour
        }
    }

    public var displayedUnitForTemperatureMeasurement: UnitTemperature {
        switch self {
            case .metric: return .celsius
            case .imperial: return .fahrenheit
        }
    }
    
    // swiftlint:disable identifier_name
    public var displayedUnitForRainAccumulationMeasurement: UnitLength {
        switch self {
            case .metric: return .millimeters
            case .imperial: return .inches
        }
    }
    
    public var displayedUnitForSnowAccumulationMeasurement: UnitLength {
        switch self {
            case .metric: return .centimeters
            case .imperial: return .inches
        }
    }
    // swiftlint:enable identifier_name
}

// MARK: WTWRandomized
extension MeasurementSystem: WTWRandomized {
    // swiftlint:disable type_name
    public enum wtw: WTWRandomizer {
        public static func random() -> MeasurementSystem {
            return nonEmptyCases.randomElement()
        }
    }
    // swiftlint:enable type_name
}
