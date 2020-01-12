import Foundation

// MARK: DailyData
public struct DailyData {
    // Times
    internal let rawApparentTemperatureHighTime: Seconds<Double>?
    internal let rawApparentTemperatureLowTime: Seconds<Double>?
    internal let rawApparentTemperatureMaxTime: Seconds<Double>?
    internal let rawApparentTemperatureMinTime: Seconds<Double>?
    internal let rawTemperatureHighTime: Seconds<Double>?
    internal let rawTemperatureLowTime: Seconds<Double>?
    internal let rawTemperatureMaxTime: Seconds<Double>?
    internal let rawTemperatureMinTime: Seconds<Double>?
    internal let rawUvIndexTime: Seconds<Double>?
    internal let rawWindGustTime: Seconds<Double>?

    // Properties requiring units
    internal let rawApparentTemperatureHigh: Celsius<Double>?
    internal let rawApparentTemperatureLow: Celsius<Double>?
    internal let rawApparentTemperatureMax: Celsius<Double>?
    internal let rawApparentTemperatureMin: Celsius<Double>?
    internal let rawTemperatureHigh: Celsius<Double>?
    internal let rawTemperatureLow: Celsius<Double>?
    internal let rawTemperatureMax: Celsius<Double>?
    internal let rawTemperatureMin: Celsius<Double>?
}

// MARK: Equatable
extension DailyData: Equatable {}

// MARK: Codable
extension DailyData: Codable {
    private enum CodingKeys: String, CodingKey {
        case rawApparentTemperatureHighTime = "apparentTemperatureHighTime"
        case rawApparentTemperatureLowTime = "apparentTemperatureLowTime"
        case rawApparentTemperatureMaxTime = "apparentTemperatureMaxTime"
        case rawApparentTemperatureMinTime = "apparentTemperatureMinTime"
        case rawTemperatureHighTime = "temperatureHighTime"
        case rawTemperatureLowTime = "temperatureLowTime"
        case rawTemperatureMaxTime = "temperatureMaxTime"
        case rawTemperatureMinTime = "temperatureMinTime"
        case rawUvIndexTime = "uvIndexTime"
        case rawWindGustTime = "windGustTime"
        case rawApparentTemperatureHigh = "apparentTemperatureHigh"
        case rawApparentTemperatureLow = "apparentTemperatureLow"
        case rawApparentTemperatureMax = "apparentTemperatureMax"
        case rawApparentTemperatureMin = "apparentTemperatureMin"
        case rawTemperatureHigh = "temperatureHigh"
        case rawTemperatureLow = "temperatureLow"
        case rawTemperatureMax = "temperatureMax"
        case rawTemperatureMin = "temperatureMin"
    }
}

// MARK: Extensions
extension DailyData {
    public var apparentTemperatureHighTime: Date? { return rawApparentTemperatureHighTime?.date }

    public var apparentTemperatureLowTime: Date? { return rawApparentTemperatureLowTime?.date }

    public var apparentTemperatureMaxTime: Date? { return rawApparentTemperatureMaxTime?.date }

    public var apparentTemperatureMinTime: Date? { return rawApparentTemperatureMinTime?.date }

    public var temperatureHighTime: Date? { return rawTemperatureHighTime?.date }

    public var temperatureLowTime: Date? { return rawTemperatureLowTime?.date }

    public var temperatureMaxTime: Date? { return rawTemperatureMaxTime?.date }

    public var temperatureMinTime: Date? { return rawTemperatureMinTime?.date }

    public var uvIndexTime: Date? { return rawUvIndexTime?.date }

    public var windGustTime: Date? { return rawWindGustTime?.date }

    public var apparentTemperatureHigh: Measurement<UnitTemperature>? {
        return rawApparentTemperatureHigh?.measurement
    }

    public var apparentTemperatureLow: Measurement<UnitTemperature>? {
        return rawApparentTemperatureLow?.measurement
    }

    public var apparentTemperatureMax: Measurement<UnitTemperature>? {
        return rawApparentTemperatureMax?.measurement
    }

    public var apparentTemperatureMin: Measurement<UnitTemperature>? {
        return rawApparentTemperatureMin?.measurement
    }

    public var temperatureHigh: Measurement<UnitTemperature>? {
        return rawTemperatureHigh?.measurement
    }

    public var temperatureLow: Measurement<UnitTemperature>? {
        return rawTemperatureLow?.measurement
    }

    public var temperatureMax: Measurement<UnitTemperature>? {
        return rawTemperatureMax?.measurement
    }

    public var temperatureMin: Measurement<UnitTemperature>? {
        return rawTemperatureMin?.measurement
    }
}
