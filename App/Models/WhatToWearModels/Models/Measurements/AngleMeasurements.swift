import Foundation

extension UnitMeasurement where DimensionType == UnitAngle {
    internal static func windBearing(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .hourly({ $0.windBearing }),
            name: NSLocalizedString("Wind Bearing", comment: ""),
            explanation: NSLocalizedString("The direction that the wind is coming from as a decimal.", comment: ""),
            rawRange: 0...360,
            rawUnit: .degrees,
            displayedMetricUnit: .degrees,
            displayedImperialUnit: .degrees
        )
    }
}
