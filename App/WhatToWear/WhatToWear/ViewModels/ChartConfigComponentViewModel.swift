import Foundation
import WhatToWearModels

internal struct ChartConfigComponentViewModel: WeatherChartComponentViewModelProtocol {
    // MARK: properties
    internal let title: String
    
    // MARK: init
    internal init(component: WeatherChartComponent, settings: GlobalSettings) {
        self.title = Self.stringRepresentation(for: component, settings: settings)
    }
}
