import Foundation

extension UnitMeasurement where DimensionType == UnitSpeed {
    internal static func windGust(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .hourly({ $0.windGust }),
            name: NSLocalizedString("Wind Gust", comment: ""),
            explanation: NSLocalizedString("The wind gust speed.", comment: ""),
            rawRange: 0...Double.infinity,
            rawUnit: .metersPerSecond,
            displayedMetricUnit: .kilometersPerHour,
            displayedImperialUnit: .milesPerHour
        )
    }
    
    internal static func windSpeed(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .hourly({ $0.windSpeed }),
            name: NSLocalizedString("Wind Speed", comment: ""),
            explanation: NSLocalizedString("The wind speed.", comment: ""),
            rawRange: 0...Double.infinity,
            rawUnit: .metersPerSecond,
            displayedMetricUnit: .kilometersPerHour,
            displayedImperialUnit: .milesPerHour
        )
    }
}
