import Foundation
import WhatToWearCommonCore
import WhatToWearCore
import WhatToWearModels

internal final class LegendViewModel {
    // MARK: properties
    private let rawComponents: NonEmptyArray<WeatherChartComponent>
    private let components: [BasicLegendComponentViewModel]
    
    // MARK: computed properties
    internal var numberOfComponents: Int {
        return components.count
    }
    
    // MARK: init
    internal init(settings: GlobalSettings) {
        self.rawComponents = WeatherChartComponent.nonEmptyCases
        self.components = WeatherChartComponent.nonEmptyCases.map { component in
            BasicLegendComponentViewModel(component: component, settings: settings)
        }
    }
    
    // MARK: retrieving components
    internal func componentViewModel(at indexPath: IndexPath) -> BasicLegendComponentViewModel {
        return components[indexPath.row]
    }
    
    internal func rawComponent(at indexPath: IndexPath) -> WeatherChartComponent {
        return rawComponents[indexPath.row]
    }
}
