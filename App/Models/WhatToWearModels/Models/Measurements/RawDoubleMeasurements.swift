import Foundation

extension RawDoubleMeasurement {
    internal static func uvIndex(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .hourly({ $0.uvIndex }),
            name: NSLocalizedString("UV Index", comment: ""),
            explanation: NSLocalizedString("The UV index.", comment: "")
        )
    }
}
