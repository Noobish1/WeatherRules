import Foundation

extension UnitMeasurement where DimensionType == UnitLength {
    internal static func precipAccumulation(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .hourly({ $0.precipAccumulation }),
            name: NSLocalizedString("Precipitation Accumulation", comment: ""),
            explanation: NSLocalizedString("The amount of snowfall accumulation expected to occur.", comment: ""),
            rawRange: 0...Double.infinity,
            rawUnit: .centimeters,
            displayedMetricUnit: .centimeters,
            displayedImperialUnit: .inches
        )
    }
    
    internal static func visibility(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .hourly({ $0.visibility }),
            name: NSLocalizedString("Visibility", comment: ""),
            explanation: NSLocalizedString("The average visibility.", comment: ""),
            rawRange: 0...Double.infinity,
            rawUnit: .kilometers,
            displayedMetricUnit: .kilometers,
            displayedImperialUnit: .miles
        )
    }
}
