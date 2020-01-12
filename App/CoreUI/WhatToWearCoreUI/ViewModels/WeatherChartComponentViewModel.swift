import Foundation
import WhatToWearModels

internal struct WeatherChartComponentViewModel: WeatherChartComponentTypeViewModelProtocol {
    // MARK: properties
    internal let color: UIColor
    internal let fillAlpha: CGFloat
    internal let isVisible: Bool
    
    // MARK: init
    internal init(component: WeatherChartComponent, componentsToShow: Set<WeatherChartComponent>) {
        self.color = Self.color(for: component)
        self.fillAlpha = Self.fillAlpha(for: component)
        self.isVisible = componentsToShow.contains(component)
    }
}
