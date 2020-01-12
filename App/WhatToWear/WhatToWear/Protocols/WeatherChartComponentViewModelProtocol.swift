import Foundation
import WhatToWearModels

// MARK: WeatherChartComponentViewModelProtocol
internal protocol WeatherChartComponentViewModelProtocol {}

// MARK: extensions
extension WeatherChartComponentViewModelProtocol {
    internal static func stringRepresentation(for component: WeatherChartComponent, settings: GlobalSettings) -> String {
        switch component {
            case .temperature: return TemperatureTypeViewModel.longTitle(for: settings.temperatureType)
            case .cloudCover: return NSLocalizedString("Cloud Cover", comment: "")
            case .chanceOfPrecip: return NSLocalizedString("Chance of Precipitation", comment: "")
            case .windGust: return WindTypeViewModel.longTitle(for: settings.windType)
            case .windDirection: return NSLocalizedString("Wind Direction", comment: "")
            case .solarNoon: return NSLocalizedString("Solar Noon", comment: "")
            case .currentTime: return NSLocalizedString("The Current Time", comment: "")
            case .humidity: return NSLocalizedString("Humidity", comment: "")
            case .sunAltitude: return NSLocalizedString("Sun Altitude", comment: "")
            case .precipAccumulation: return NSLocalizedString("Precipitation Amount", comment: "")
        }
    }
}
