import Foundation
import WhatToWearCore

// MARK: GlobalSettings
public struct PreUpdatesGlobalSettings: Codable, Equatable {
    // MARK: properties
    public let measurementSystem: MeasurementSystem
    public let shownComponents: [WeatherChartComponent: Bool]
    public let appBackgroundOptions: AppBackgroundOptions

    // MARK: init
    public init(
        measurementSystem: MeasurementSystem,
        shownComponents: [WeatherChartComponent: Bool],
        appBackgroundOptions: AppBackgroundOptions
    ) {
        self.measurementSystem = measurementSystem
        self.shownComponents = shownComponents
        self.appBackgroundOptions = appBackgroundOptions
    }
}

// MARK: Migratable
extension PreUpdatesGlobalSettings: Migratable {
    public init(previousObject: PreBackgroundsGlobalSettings) {
        self.init(
            measurementSystem: previousObject.measurementSystem,
            shownComponents: previousObject.shownComponents,
            appBackgroundOptions: .original
        )
    }
}
