import Foundation

extension UnitMeasurement where DimensionType == UnitPressure {
    internal static func airPressure(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .hourly({ $0.pressure }),
            name: NSLocalizedString("Sea-level Air Pressure", comment: ""),
            explanation: NSLocalizedString("The sea-level air pressure.", comment: ""),
            rawRange: 0...Double.infinity,
            rawUnit: .hectopascals,
            displayedMetricUnit: .hectopascals,
            displayedImperialUnit: .millibars
        )
    }
}
