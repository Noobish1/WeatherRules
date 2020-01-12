import Foundation

extension UnitMeasurement where DimensionType == UnitTemperature {
    internal static func feelsLikeTemperature(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .hourly({ $0.apparentTemperature }),
            name: NSLocalizedString("'Feels-like' Temperature", comment: ""),
            explanation: NSLocalizedString("The 'feels like' temperature.", comment: ""),
            rawRange: -Double.infinity...Double.infinity,
            rawUnit: .celsius,
            displayedMetricUnit: .celsius,
            displayedImperialUnit: .fahrenheit
        )
    }
    
    internal static func airTemperature(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .hourly({ $0.temperature }),
            name: NSLocalizedString("Air Temperature", comment: ""),
            explanation: NSLocalizedString("The air temperature.", comment: ""),
            rawRange: -Double.infinity...Double.infinity,
            rawUnit: .celsius,
            displayedMetricUnit: .celsius,
            displayedImperialUnit: .fahrenheit
        )
    }
    
    internal static func dewPoint(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .hourly({ $0.dewPoint }),
            name: NSLocalizedString("Dew Point", comment: ""),
            explanation: NSLocalizedString("The dew point.", comment: ""),
            rawRange: -Double.infinity...Double.infinity,
            rawUnit: .celsius,
            displayedMetricUnit: .celsius,
            displayedImperialUnit: .fahrenheit
        )
    }
    
    internal static func apparentTemperatureHigh(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .daily({ $0.apparentTemperatureHigh }),
            name: NSLocalizedString("'Feels-like' Temperature High", comment: ""),
            explanation: NSLocalizedString("The daytime high 'feels-like' temperature.", comment: ""),
            rawRange: -Double.infinity...Double.infinity,
            rawUnit: .celsius,
            displayedMetricUnit: .celsius,
            displayedImperialUnit: .fahrenheit
        )
    }
    
    internal static func apparentTemperatureLow(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .daily({ $0.apparentTemperatureLow }),
            name: NSLocalizedString("'Feels-like' Temperature Low", comment: ""),
            explanation: NSLocalizedString("The overnight low 'feels-like' temperature.", comment: ""),
            rawRange: -Double.infinity...Double.infinity,
            rawUnit: .celsius,
            displayedMetricUnit: .celsius,
            displayedImperialUnit: .fahrenheit
        )
    }
    
    internal static func apparentTemperatureMax(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .daily({ $0.apparentTemperatureMax }),
            name: NSLocalizedString("'Feels-like' Temperature Max", comment: ""),
            explanation: NSLocalizedString("The maximum 'feels-like' temperature.", comment: ""),
            rawRange: -Double.infinity...Double.infinity,
            rawUnit: .celsius,
            displayedMetricUnit: .celsius,
            displayedImperialUnit: .fahrenheit
        )
    }
    
    internal static func apparentTemperatureMin(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .daily({ $0.apparentTemperatureMin }),
            name: NSLocalizedString("'Feels-like' Temperature Min", comment: ""),
            explanation: NSLocalizedString("The minimum 'feels-like' temperature.", comment: ""),
            rawRange: -Double.infinity...Double.infinity,
            rawUnit: .celsius,
            displayedMetricUnit: .celsius,
            displayedImperialUnit: .fahrenheit
        )
    }
    
    internal static func temperatureHigh(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .daily({ $0.temperatureHigh }),
            name: NSLocalizedString("Air Temperature High", comment: ""),
            explanation: NSLocalizedString("The daytime high air temperature.", comment: ""),
            rawRange: -Double.infinity...Double.infinity,
            rawUnit: .celsius,
            displayedMetricUnit: .celsius,
            displayedImperialUnit: .fahrenheit
        )
    }
    
    internal static func temperatureLow(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .daily({ $0.temperatureLow }),
            name: NSLocalizedString("Air Temperature Low", comment: ""),
            explanation: NSLocalizedString("The overnight low air temperature.", comment: ""),
            rawRange: -Double.infinity...Double.infinity,
            rawUnit: .celsius,
            displayedMetricUnit: .celsius,
            displayedImperialUnit: .fahrenheit
        )
    }
    
    internal static func temperatureMax(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .daily({ $0.temperatureMax }),
            name: NSLocalizedString("Air Temperature Max", comment: ""),
            explanation: NSLocalizedString("The maximum air temperature.", comment: ""),
            rawRange: -Double.infinity...Double.infinity,
            rawUnit: .celsius,
            displayedMetricUnit: .celsius,
            displayedImperialUnit: .fahrenheit
        )
    }
    
    internal static func temperatureMin(for id: MeasurementID) -> Self {
        return Self(
            id: id,
            value: .daily({ $0.temperatureMin }),
            name: NSLocalizedString("Air Temperature Min", comment: ""),
            explanation: NSLocalizedString("The minimum air temperature.", comment: ""),
            rawRange: -Double.infinity...Double.infinity,
            rawUnit: .celsius,
            displayedMetricUnit: .celsius,
            displayedImperialUnit: .fahrenheit
        )
    }
}
