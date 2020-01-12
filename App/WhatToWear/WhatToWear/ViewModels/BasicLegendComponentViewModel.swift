import Foundation
import WhatToWearCoreUI
import WhatToWearModels

internal struct BasicLegendComponentViewModel: WeatherChartComponentViewModelProtocol, WeatherChartComponentTypeViewModelProtocol {
    // MARK: properties
    internal let title: String
    internal let componentType: WeatherChartComponentType
    
    // MARK: init
    internal init(component: WeatherChartComponent, settings: GlobalSettings) {
        self.title = Self.stringRepresentation(for: component, settings: settings)
        self.componentType = Self.componentType(for: component)
    }
    
    // MARK: static init helpers
    internal static func componentType(for component: WeatherChartComponent) -> WeatherChartComponentType {
        switch component {
            case .temperature: return .line(color: color(for: component))
            case .cloudCover: return .filledLine(color: color(for: component), fillAlpha: fillAlpha(for: component))
            case .chanceOfPrecip: return .filledLine(color: color(for: component), fillAlpha: fillAlpha(for: component))
            case .windGust: return .line(color: color(for: component))
            case .solarNoon: return .scatter(color: color(for: component), testString: "●")
            case .currentTime: return .line(color: color(for: component))
            case .humidity: return .line(color: color(for: component))
            case .windDirection: return .scatter(color: color(for: component), testString: "N")
            case .sunAltitude: return .line(color: color(for: component))
            case .precipAccumulation: return .scatter(color: color(for: component), testString: "2")
        }
    }
}
