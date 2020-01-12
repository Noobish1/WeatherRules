import Foundation

extension PercentageMeasurement {
    internal static func precipMeasurement(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .hourly({ $0.chanceOfPrecipitation }),
            name: NSLocalizedString("Chance of Precipitation", comment: ""),
            explanation: NSLocalizedString("The probability of precipitation occurring.", comment: "")
        )
    }
    
    internal static func cloudCover(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .hourly({ $0.cloudCover }),
            name: NSLocalizedString("Cloud Cover", comment: ""),
            explanation: NSLocalizedString("The percentage of sky occluded by clouds.", comment: "")
        )
    }
    
    internal static func humidity(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .hourly({ $0.humidity }),
            name: NSLocalizedString("Humidity", comment: ""),
            explanation: NSLocalizedString("The relative humidity.", comment: "")
        )
    }
}
