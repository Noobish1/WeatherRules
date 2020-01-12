import Foundation

// MARK: GlobalSettings
public struct PreWhatsNewGlobalSettings: Codable, Equatable {
    // MARK: properties
    public let measurementSystem: MeasurementSystem
    public let shownComponents: [WeatherChartComponent: Bool]
    public let appBackgroundOptions: AppBackgroundOptions
    public let lastSeenUpdate: LatestAppUpdate?
    public let lastUpdateAvailable: LatestAppUpdate?

    // MARK: init
    public init(
        measurementSystem: MeasurementSystem,
        shownComponents: [WeatherChartComponent: Bool],
        appBackgroundOptions: AppBackgroundOptions,
        lastSeenUpdate: LatestAppUpdate?,
        lastUpdateAvailable: LatestAppUpdate?
    ) {
        self.measurementSystem = measurementSystem
        self.shownComponents = shownComponents
        self.appBackgroundOptions = appBackgroundOptions
        self.lastSeenUpdate = lastSeenUpdate
        self.lastUpdateAvailable = lastUpdateAvailable
    }
}

// MARK: Migratable
extension PreWhatsNewGlobalSettings: Migratable {
    public init(previousObject: PreUpdatesGlobalSettings) {
        self.init(
            measurementSystem: previousObject.measurementSystem,
            shownComponents: previousObject.shownComponents,
            appBackgroundOptions: previousObject.appBackgroundOptions,
            lastSeenUpdate: nil,
            lastUpdateAvailable: nil
        )
    }
}
