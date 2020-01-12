import Foundation

// MARK: DataPoint
public struct HourlyDataPoint {
    private enum CodingKeys: String, CodingKey {
        case rawTime = "time"
        case cloudCover = "cloudCover"
        case rawTemperature = "temperature"
        case rawApparentTemperature = "apparentTemperature"
        case chanceOfPrecipitation = "precipProbability"
        case precipitationType = "precipType"
        case rawWindSpeed = "windSpeed"
        case rawWindGust = "windGust"
        case humidity = "humidity"
        case rawWindBearing = "windBearing"
        case rawDewPoint = "dewPoint"
        case rawPrecipAccumulation = "precipAccumulation"
        case rawPrecipIntensity = "precipIntensity"
        case rawPressure = "pressure"
        case uvIndex = "uvIndex"
        case rawVisibility = "visibility"
    }

    public let cloudCover: Percentage<Double>?
    public let chanceOfPrecipitation: Percentage<Double>?
    public let humidity: Percentage<Double>?
    public let precipitationType: PrecipitationType?
    public let uvIndex: Double?

    internal let rawTime: Seconds<Double>
    internal let rawWindBearing: Degrees<Double>?
    internal let rawApparentTemperature: Celsius<Double>
    internal let rawTemperature: Celsius<Double>
    internal let rawWindSpeed: MetersPerSecond<Double>?
    internal let rawWindGust: MetersPerSecond<Double>?
    internal let rawDewPoint: Celsius<Double>?
    internal let rawPrecipAccumulation: Centimeters<Double>?
    internal let rawPrecipIntensity: Millimeters<Double>?
    internal let rawPressure: Hectopascals<Double>?
    internal let rawVisibility: Kilometers<Double>?
}

// MARK: Codable
extension HourlyDataPoint: Codable {}

// MARK: Equatable
extension HourlyDataPoint: Equatable {}

// MARK: computed properties
extension HourlyDataPoint {
    public var time: Date {
        return rawTime.date
    }

    public var dayOfWeek: DayOfWeek {
        return DayOfWeek(date: time)
    }

    public var visibility: Measurement<UnitLength>? {
        return rawVisibility?.measurement
    }

    public var pressure: Measurement<UnitPressure>? {
        return rawPressure?.measurement
    }

    public var precipAccumulation: Measurement<UnitLength>? {
        return rawPrecipAccumulation?.measurement
    }
    
    public var precipIntensity: Measurement<UnitLength>? {
        return rawPrecipIntensity?.measurement
    }

    public var dewPoint: Measurement<UnitTemperature>? {
        return rawDewPoint?.measurement
    }

    public var windDirection: WindDirection? {
        return WindDirection(windBearing: windBearing?.value)
    }

    public var windBearing: Measurement<UnitAngle>? {
        return rawWindBearing?.measurement
    }

    public var apparentTemperature: Measurement<UnitTemperature> {
        return rawApparentTemperature.measurement
    }

    public var temperature: Measurement<UnitTemperature> {
        return rawTemperature.measurement
    }

    public var windGust: Measurement<UnitSpeed>? {
        return rawWindGust?.measurement
    }
    
    public var windSpeed: Measurement<UnitSpeed>? {
        return rawWindSpeed?.measurement
    }
}
