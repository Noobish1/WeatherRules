import Foundation
import WhatToWearCore

// MARK: MeasurementID
public enum MeasurementID: Int, Codable, Hashable, NonEmptyCaseIterable {
    case precip = 0
    case cloudCover = 1
    case feelsLikeTemperature = 2
    case airTemperature = 3
    case windGust = 4
    case humidity = 5
    case precipType = 6
    case time = 7
    case windBearing = 8
    case windDirection = 9
    case uvIndex = 10
    case dewPoint = 11
    case precipAccumulation = 12
    case pressure = 13
    case visibility = 14
    case sunAltitude = 15
    case apparentTemperatureHighTime = 16
    case apparentTemperatureLowTime = 17
    case apparentTemperatureMaxTime = 18
    case apparentTemperatureMinTime = 19
    case temperatureHighTime = 20
    case temperatureLowTime = 21
    case temperatureMaxTime = 22
    case temperatureMinTime = 23
    case uvIndexTime = 24
    case windGustTime = 25
    case apparentTemperatureHigh = 26
    case apparentTemperatureLow = 27
    case apparentTemperatureMax = 28
    case apparentTemperatureMin = 29
    case temperatureHigh = 30
    case temperatureLow = 31
    case temperatureMax = 32
    case temperatureMin = 33
    case dayOfWeek = 34
    case windSpeed = 35
}

// MARK: Measurement
public enum WeatherMeasurement: Equatable {
    case double(DoubleMeasurement)
    case enumeration(EnumMeasurement)
    case time(TimeMeasurement)

    // MARK: retrieving WeatherMeasurements
    public static var hourlyMeasurements: [Self] {
        return MeasurementID.nonEmptyCases
            .map(WeatherMeasurement.init)
            .filter { $0.basicValue == .hourly }
    }

    public static var dailyMeasurements: [Self] {
        return MeasurementID.nonEmptyCases
            .map(WeatherMeasurement.init)
            .filter { $0.basicValue == .daily }
    }

    // MARK: init
    // swiftlint:disable cyclomatic_complexity
    public init(id: MeasurementID) {
        switch id {
            case .precip:
                self = .double(.percentage(.precipMeasurement(for: id)))
            case .cloudCover:
                self = .double(.percentage(.cloudCover(for: id)))
            case .feelsLikeTemperature:
                self = .double(.temperature(.feelsLikeTemperature(for: id)))
            case .airTemperature:
                self = .double(.temperature(.airTemperature(for: id)))
            case .windGust:
                self = .double(.speed(.windGust(for: id)))
            case .windSpeed:
                self = .double(.speed(.windSpeed(for: id)))
            case .humidity:
                self = .double(.percentage(.humidity(for: id)))
            case .precipType:
                self = .enumeration(.precipType(.precipType(for: id)))
            case .time:
                self = .time(.currentTime(for: id))
            case .windBearing:
                self = .double(.angle(.windBearing(for: id)))
            case .windDirection:
                self = .enumeration(.windDirection(.windDirection(for: id)))
            case .uvIndex:
                self = .double(.rawDouble(.uvIndex(for: id)))
            case .dewPoint:
                self = .double(.temperature(.dewPoint(for: id)))
            case .precipAccumulation:
                self = .double(.length(.precipAccumulation(for: id)))
            case .pressure:
                self = .double(.pressure(.airPressure(for: id)))
            case .visibility:
                self = .double(.length(.visibility(for: id)))
            case .sunAltitude:
                self = .double(.calculatedPercentage(.sunAltitude(for: id)))
            case .apparentTemperatureHighTime:
                self = .time(.apparentTemperatureHighTime(for: id))
            case .apparentTemperatureLowTime:
                self = .time(.apparentTemperatureLowTime(for: id))
            case .apparentTemperatureMaxTime:
                self = .time(.apparentTemperatureMaxTime(for: id))
            case .apparentTemperatureMinTime:
                self = .time(.apparentTemperatureMinTime(for: id))
            case .temperatureHighTime:
                self = .time(.temperatureHighTime(for: id))
            case .temperatureLowTime:
                self = .time(.temperatureLowTime(for: id))
            case .temperatureMaxTime:
                self = .time(.temperatureMaxTime(for: id))
            case .temperatureMinTime:
                self = .time(.temperatureMinTime(for: id))
            case .uvIndexTime:
                self = .time(.uvIndexTime(for: id))
            case .windGustTime:
                self = .time(.windGustTime(for: id))
            case .apparentTemperatureHigh:
                self = .double(.temperature(.apparentTemperatureHigh(for: id)))
            case .apparentTemperatureLow:
                self = .double(.temperature(.apparentTemperatureLow(for: id)))
            case .apparentTemperatureMax:
                self = .double(.temperature(.apparentTemperatureMax(for: id)))
            case .apparentTemperatureMin:
                self = .double(.temperature(.apparentTemperatureMin(for: id)))
            case .temperatureHigh:
                self = .double(.temperature(.temperatureHigh(for: id)))
            case .temperatureLow:
                self = .double(.temperature(.temperatureLow(for: id)))
            case .temperatureMax:
                self = .double(.temperature(.temperatureMax(for: id)))
            case .temperatureMin:
                self = .double(.temperature(.temperatureMin(for: id)))
            case .dayOfWeek:
                self = .enumeration(.dayOfWeek(.dayOfWeek(for: id)))
        }
    }
    // swiftlint:enable cyclomatic_complexity
}

// MARK: BasicMeasurementProtocol
extension WeatherMeasurement: BasicMeasurementProtocol {
    // MARK: computed properties
    private var wrapper: BasicMeasurementProtocol {
        switch self {
            case .double(let measurement): return measurement
            case .enumeration(let measurement): return measurement
            case .time(let measurement): return measurement
        }
    }

    public var id: MeasurementID {
        return wrapper.id
    }

    public var name: String {
        return wrapper.name
    }

    public var basicValue: BasicMeasurementValue {
        return wrapper.basicValue
    }

    public var explanation: String {
        return wrapper.explanation
    }
}
