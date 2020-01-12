import WhatToWearCommonCore
import WhatToWearModels

extension WeatherChartComponent {
    internal static var componentsOnlyOnTheTopChart: [WeatherChartComponent] {
        return Self.allCases.filter { $0.chartPositions == [.top] }
    }
    
    internal static var componentsOnlyOnTheBottomChart: [WeatherChartComponent] {
        return Self.allCases.filter { $0.chartPositions == [.bottom] }
    }
    
    private var chartPositions: [WeatherChartView.Position] {
        switch self {
            case .temperature: return [.bottom]
            case .cloudCover: return [.top]
            case .chanceOfPrecip: return [.bottom]
            case .windGust: return [.top]
            case .windDirection: return [.top]
            case .solarNoon: return [.top]
            case .currentTime: return [.top, .bottom]
            case .humidity: return [.top]
            case .sunAltitude: return [.top]
            case .precipAccumulation: return [.bottom]
        }
    }
}
