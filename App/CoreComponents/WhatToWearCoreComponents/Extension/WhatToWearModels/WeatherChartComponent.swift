import Foundation
import WhatToWearModels

extension WeatherChartComponent {
    internal var versionWhenAdded: GlobalSettingsVersion {
        switch self {
            case .temperature: return .initial
            case .cloudCover: return .initial
            case .chanceOfPrecip: return .initial
            case .windGust: return .initial
            case .windDirection: return .rulesSetToRulesDict
            case .solarNoon: return .initial
            case .currentTime: return .initial
            case .humidity: return .initial
            case .sunAltitude: return .rulesSetToRulesDict
            // This wasn't actually added in this but it just needs to not be .initial
            case .precipAccumulation: return .rulesSetToRulesDict
        }
    }
}
