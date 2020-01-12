import Foundation
import WhatToWearCommonModels

extension SelectableMeasurement where Value == PrecipitationType {
    internal static func precipType(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .hourly({ $0.precipitationType }),
            name: NSLocalizedString("Precipitation Type", comment: ""),
            explanation: NSLocalizedString("The type of precipitation occurring.", comment: "")
        )
    }
}

extension SelectableMeasurement where Value == WindDirection {
    internal static func windDirection(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .hourly({ $0.windDirection }),
            name: NSLocalizedString("Wind Direction", comment: ""),
            explanation: NSLocalizedString("The direction that the wind is coming from as a compass direction.", comment: "")
        )
    }
}

extension SelectableMeasurement where Value == DayOfWeek {
    internal static func dayOfWeek(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .hourly({ $0.dayOfWeek }),
            name: NSLocalizedString("Day of Week", comment: ""),
            explanation: NSLocalizedString("The day of week.", comment: "")
        )
    }
}
