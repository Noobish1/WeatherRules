import Foundation
import WhatToWearModels

internal struct LegendComponentViewModel: WeatherChartComponentViewModelProtocol {
    // MARK: properties
    internal let title: String
    internal let description: String
    internal let analyticsValue: String
    
    // MARK: init
    internal init(component: WeatherChartComponent, settings: GlobalSettings) {
        self.title = Self.stringRepresentation(for: component, settings: settings)
        self.description = Self.descriptionText(for: component, settings: settings)
        self.analyticsValue = Self.analyticsValue(for: component)
    }
    
    // MARK: static init helpers
    private static func analyticsValue(for component: WeatherChartComponent) -> String {
        // We don't want these to be localized
        switch component {
            case .temperature: return "Temperature"
            case .cloudCover: return "Cloud Cover"
            case .chanceOfPrecip: return "Chance of Precipitation"
            case .windGust: return "Wind Gust"
            case .windDirection: return "Wind Direction"
            case .solarNoon: return "Solar Noon"
            case .currentTime: return "The Current Time"
            case .humidity: return "Humidity"
            case .sunAltitude: return "Sun Altitude"
            case .precipAccumulation: return "Precipitation Amount"
        }
    }
    
    // swiftlint:disable line_length
    private static func descriptionText(for component: WeatherChartComponent, settings: GlobalSettings) -> String {
        switch component {
            case .temperature:
                let tempTitle = TemperatureTypeViewModel.longTitle(for: settings.temperatureType)
                
                let format = NSLocalizedString("%@ is shown as a red line on the chart and the left axis.\n\nThe bottom value on the left axis is the low for the day and the top value is the high for the day.", comment: "")
            
                return String(format: format, arguments: [tempTitle])
            case .cloudCover:
                return NSLocalizedString("Cloud Cover is shown as a solid white mass on the chart. It is shown as a percentage and is reversed so that zero is at the top of the graph and 100 is at the bottom.\n\nThe chart will be completely filled if there is 100% cloud cover for the entire day. It is displayed in this way to represent clouds in the sky.", comment: "")
            case .chanceOfPrecip:
                return NSLocalizedString("Chance of precipitation is shown as a transparent mass on the chart.\n\nIt is shown as a percentage, zero is at the bottom of the graph and 100 is at the top.\n\nThe chart will be completely filled if there is 100% chance of precipitation for the entire day.\n\nThe mass will be a darker blue color when it is rain, lighter blue when it is sleet and white when it is snow.", comment: "")
            case .windGust:
                let windTitle = WindTypeViewModel.longTitle(for: settings.windType)
                
                let format = NSLocalizedString("%@ is shown as a grey line on the chart and the right axis.\n\nThe bottom value is the low for the day and the top value is the high.", comment: "")
            
                return String(format: format, arguments: [windTitle])
            case .windDirection:
                return NSLocalizedString("Wind Direction is shown as an arrow and denotes a compass direction. Up is North, down is South, left is West, right is East.", comment: "")
            case .solarNoon:
                return NSLocalizedString("The yellow sun icon denotes Solar Noon, the time at which the sun is at its highest point in the sky.", comment: "")
            case .currentTime:
                return NSLocalizedString("The vertical orange line on the graph denotes the current time and more specifically the time when the forecast was retrieved.", comment: "")
            case .humidity:
                return NSLocalizedString("Humidity is shown as a green line on the chart.\n\nIt is shown as a percentage, zero is at the bottom of the graph and 100 is at the top.", comment: "")
            case .sunAltitude:
                return NSLocalizedString("Sun Altitude is shown as a yellow line on the chart.\n\nIt is shown as a percentage, zero is at the bottom (when the sun is below the horizon) and 100 is at the top (when the sun is at its highest point, also where the sun is shown).", comment: "")
            case .precipAccumulation:
                return NSLocalizedString("Precipitation Accumulation is shown as numbers above the precipitation chance line if that component is enabled. The numbers will only show when the amount is greater than 0mm.\n\nThe numbers will be a darker blue color when it is rain, lighter blue when it is sleet and white when it is snow.", comment: "")
        }
    }
    // swiftlint:enable line_length
}
