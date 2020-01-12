import Foundation
import WhatToWearCore

// MARK: WeatherChartComponent
public enum WeatherChartComponent: String, Hashable, Codable, NonEmptyCaseIterable {
    // 1.2.0
    case temperature = "temperature"
    case cloudCover = "cloudCover"
    case chanceOfPrecip = "chanceOfPrecip"
    case windGust = "windGust"
    case solarNoon = "solarNoon"
    case currentTime = "currentTime"
    case humidity = "humidity"

    // 1.3.0
    case windDirection = "windDirection"
    case sunAltitude = "sunPosition"
    
    // 2.1.0
    case precipAccumulation = "precipAccumulation"

    // MARK: computed properties
    public static var defaultMapping: [Self: Bool] {
        return Dictionary(uniqueKeysWithValues: allCases.map { ($0, $0.shownByDefault) })
    }

    public var shownByDefault: Bool {
        switch self {
            case .temperature: return true
            case .cloudCover: return true
            case .chanceOfPrecip: return true
            case .windGust: return true
            case .windDirection: return true
            case .solarNoon: return true
            case .currentTime: return true
            case .humidity: return true
            case .sunAltitude: return false
            case .precipAccumulation: return false
        }
    }
}
