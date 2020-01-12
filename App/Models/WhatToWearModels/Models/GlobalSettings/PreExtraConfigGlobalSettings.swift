import Foundation
import WhatToWearCore

// MARK: GlobalSettings
public struct PreExtraConfigGlobalSettings: Codable, Equatable, Withable {
    // MARK: properties
    public var measurementSystem: MeasurementSystem
    public var shownComponents: [WeatherChartComponent: Bool]
    public var appBackgroundOptions: AppBackgroundOptions
    public var lastSeenUpdate: LatestAppUpdate?
    public var lastUpdateAvailable: LatestAppUpdate?
    public var lastWhatsNewVersionSeen: OperatingSystemVersion
    
    // MARK: init
    public init(
        measurementSystem: MeasurementSystem,
        shownComponents: [WeatherChartComponent: Bool],
        appBackgroundOptions: AppBackgroundOptions,
        lastSeenUpdate: LatestAppUpdate?,
        lastUpdateAvailable: LatestAppUpdate?,
        lastWhatsNewVersionSeen: OperatingSystemVersion
    ) {
        self.measurementSystem = measurementSystem
        self.shownComponents = shownComponents
        self.appBackgroundOptions = appBackgroundOptions
        self.lastSeenUpdate = lastSeenUpdate
        self.lastUpdateAvailable = lastUpdateAvailable
        self.lastWhatsNewVersionSeen = lastWhatsNewVersionSeen
    }
}

// MARK: Migratable
extension PreExtraConfigGlobalSettings: Migratable {
    public init(previousObject: PreWhatsNewGlobalSettings) {
        self.init(
            measurementSystem: previousObject.measurementSystem,
            shownComponents: previousObject.shownComponents,
            appBackgroundOptions: previousObject.appBackgroundOptions,
            lastSeenUpdate: previousObject.lastSeenUpdate,
            lastUpdateAvailable: previousObject.lastUpdateAvailable,
            // We default to 1.4.0 because thats the version we added this
            lastWhatsNewVersionSeen: OperatingSystemVersion(1, 4, 0)
        )
    }
}
