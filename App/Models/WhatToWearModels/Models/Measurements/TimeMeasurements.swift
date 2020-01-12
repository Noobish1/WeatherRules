import Foundation

extension TimeMeasurement {
    internal static func currentTime(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .hourly({ $0.time }),
            name: NSLocalizedString("Time", comment: ""),
            explanation: NSLocalizedString("The time of day.", comment: "")
        )
    }
    
    internal static func apparentTemperatureHighTime(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .daily({ $0.apparentTemperatureHighTime }),
            name: NSLocalizedString("'Feels-like' Temperature High Time", comment: ""),
            explanation: NSLocalizedString("The time when the daytime high 'feels-like' temperature occurs.", comment: "")
        )
    }
    
    internal static func apparentTemperatureLowTime(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .daily({ $0.apparentTemperatureLowTime }),
            name: NSLocalizedString("'Feels-like' Temperature Low Time", comment: ""),
            explanation: NSLocalizedString("The time when the overnight low 'feels-like' temperature occurs.", comment: "")
        )
    }
    
    internal static func apparentTemperatureMaxTime(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .daily({ $0.apparentTemperatureMaxTime }),
            name: NSLocalizedString("'Feels-like' Temperature Max Time", comment: ""),
            explanation: NSLocalizedString("The time when the maximum 'feels-like' temperature occurs.", comment: "")
        )
    }
    
    internal static func apparentTemperatureMinTime(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .daily({ $0.apparentTemperatureMinTime }),
            name: NSLocalizedString("'Feels-like' Temperature Min Time", comment: ""),
            explanation: NSLocalizedString("The time when the minimum 'feels-like' temperature occurs.", comment: "")
        )
    }
    
    internal static func temperatureHighTime(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .daily({ $0.temperatureHighTime }),
            name: NSLocalizedString("Air Temperature High Time", comment: ""),
            explanation: NSLocalizedString("The time when the daytime high air temperature occurs.", comment: "")
        )
    }
    
    internal static func temperatureLowTime(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .daily({ $0.temperatureLowTime }),
            name: NSLocalizedString("Air Temperature Low Time", comment: ""),
            explanation: NSLocalizedString("The time when the overnight low air temperature occurs.", comment: "")
        )
    }
    
    internal static func temperatureMaxTime(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .daily({ $0.temperatureMaxTime }),
            name: NSLocalizedString("Air Temperature Max Time", comment: ""),
            explanation: NSLocalizedString("The time when the maximum air temperature occurs.", comment: "")
        )
    }
    
    internal static func temperatureMinTime(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .daily({ $0.temperatureMinTime }),
            name: NSLocalizedString("Air Temperature Min Time", comment: ""),
            explanation: NSLocalizedString("The time when the minimum air temperature occurs.", comment: "")
        )
    }
    
    internal static func uvIndexTime(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .daily({ $0.uvIndexTime }),
            name: NSLocalizedString("UV Index High Time", comment: ""),
            explanation: NSLocalizedString("The time when the maximum uvIndex occurs.", comment: "")
        )
    }
    
    internal static func windGustTime(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .daily({ $0.windGustTime }),
            name: NSLocalizedString("Wind Gust High Time", comment: ""),
            explanation: NSLocalizedString("The time when the maximum wind gust speed occurs.", comment: "")
        )
    }
}
