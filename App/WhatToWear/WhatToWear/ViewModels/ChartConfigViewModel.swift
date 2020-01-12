import Foundation
import WhatToWearCommonCore
import WhatToWearCore
import WhatToWearModels

internal final class ChartConfigViewModel {
    // MARK: properties
    private let allComponents = WeatherChartComponent.allCases
    private let settings: GlobalSettings
    
    internal let indexPathsForPreselecting: [IndexPath]
    internal let numberOfComponents: Int
    
    // MARK: init
    internal init(settings: GlobalSettings) {
        self.settings = settings
        self.indexPathsForPreselecting = Self.preselectedIndexPaths(
            initialComponents: settings.shownComponentsSet, allComponents: allComponents
        )
        self.numberOfComponents = allComponents.count
    }
    
    // MARK: static init helpers
    private static func preselectedIndexPaths(
        initialComponents: Set<WeatherChartComponent>,
        allComponents: [WeatherChartComponent]
    ) -> [IndexPath] {
        return allComponents
            .enumerated()
            .filter { _, component in
                initialComponents.contains(component)
            }
            .map { index, _ in index }
            .map { IndexPath(row: $0, section: 0) }
    }
    
    // MARK: component viewmodels
    internal func componentViewModel(at indexPath: IndexPath) -> ChartConfigComponentViewModel {
        return ChartConfigComponentViewModel(component: allComponents[indexPath.row], settings: settings)
    }
    
    // MARK: making new settings for saving
    internal func makeNewSettingsForSaving(fromSelectedIndexPaths selectedIndexPaths: [IndexPath]) -> GlobalSettings {
        let selectedComponents = Set(selectedIndexPaths.map { allComponents[$0.row] })

        return settings.with(selectedComponents: selectedComponents)
    }
}
