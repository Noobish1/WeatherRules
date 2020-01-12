import Foundation
import WhatToWearModels

// MARK: WeathrChartComponentTypeViewModelProtocol
public protocol WeatherChartComponentTypeViewModelProtocol {}

// MARK: extensions
extension WeatherChartComponentTypeViewModelProtocol {
    // MARK: static init helpers
    public static func color(for component: WeatherChartComponent) -> UIColor {
        switch component {
            case .temperature: return .red
            case .cloudCover: return .white
            case .chanceOfPrecip: return UIColor(hex: 0x1695c4)
            case .windGust: return UIColor.white.darker(by: 40.percent)
            case .solarNoon: return .yellow
            case .currentTime: return .orange
            case .humidity: return UIColor(hex: 0x1F8722)
            case .windDirection: return UIColor.white.darker(by: 40.percent)
            case .sunAltitude: return UIColor(hex: 0xffda38)
            case .precipAccumulation: return UIColor(hex: 0x1695c4).lighter(by: 30.percent)
        }
    }
    
    public static func fillAlpha(for component: WeatherChartComponent) -> CGFloat {
        switch component {
            case .temperature, .windGust, .solarNoon, .currentTime,
                 .humidity, .windDirection, .sunAltitude, .precipAccumulation:
                return 1
            case .cloudCover: return 0.9
            case .chanceOfPrecip: return 0.7
        }
    }
}
