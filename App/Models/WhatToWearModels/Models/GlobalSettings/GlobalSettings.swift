import Foundation
import WhatToWearCore

// MARK: GlobalSettings
public struct GlobalSettings: Codable, Equatable, Withable {
    // MARK: properties
    public var measurementSystem: MeasurementSystem
    public var shownComponents: [WeatherChartComponent: Bool]
    public var appBackgroundOptions: AppBackgroundOptions
    public var lastSeenUpdate: LatestAppUpdate?
    public var lastUpdateAvailable: LatestAppUpdate?
    public var lastWhatsNewVersionSeen: OperatingSystemVersion
    public var temperatureType: TemperatureType
    public var windType: WindType
    public var whatsNewOnLaunch: Bool

    // MARK: computed static properties
    public static var `default`: Self {
        return Self(
            measurementSystem: .metric,
            shownComponents: WeatherChartComponent.defaultMapping,
            appBackgroundOptions: .darkBlue,
            lastSeenUpdate: nil,
            lastUpdateAvailable: nil,
            // We default to 1.4.0 because thats the version we added this
            lastWhatsNewVersionSeen: OperatingSystemVersion(1, 4, 0),
            temperatureType: .apparent,
            windType: .gust,
            whatsNewOnLaunch: true
        )
    }

    // MARK: computed properties
    public var shownComponentsSet: Set<WeatherChartComponent> {
        return Set(shownComponents.filter { $0.1 }.map { $0.0 })
    }

    public var updateWarningState: UpdateWarningState {
        return UpdateWarningState(globalSettings: self)
    }

    // MARK: init
    public init(
        measurementSystem: MeasurementSystem,
        shownComponents: [WeatherChartComponent: Bool],
        appBackgroundOptions: AppBackgroundOptions,
        lastSeenUpdate: LatestAppUpdate?,
        lastUpdateAvailable: LatestAppUpdate?,
        lastWhatsNewVersionSeen: OperatingSystemVersion,
        temperatureType: TemperatureType,
        windType: WindType,
        whatsNewOnLaunch: Bool
    ) {
        self.measurementSystem = measurementSystem
        self.shownComponents = shownComponents
        self.appBackgroundOptions = appBackgroundOptions
        self.lastSeenUpdate = lastSeenUpdate
        self.lastUpdateAvailable = lastUpdateAvailable
        self.lastWhatsNewVersionSeen = lastWhatsNewVersionSeen
        self.temperatureType = temperatureType
        self.windType = windType
        self.whatsNewOnLaunch = whatsNewOnLaunch
    }
}

// MARK: Migratable
extension GlobalSettings: Migratable {
    public init(previousObject: PreExtraConfigGlobalSettings) {
        self.init(
            measurementSystem: previousObject.measurementSystem,
            shownComponents: previousObject.shownComponents,
            appBackgroundOptions: previousObject.appBackgroundOptions,
            lastSeenUpdate: previousObject.lastSeenUpdate,
            lastUpdateAvailable: previousObject.lastUpdateAvailable,
            lastWhatsNewVersionSeen: previousObject.lastWhatsNewVersionSeen,
            temperatureType: Self.default.temperatureType,
            windType: Self.default.windType,
            whatsNewOnLaunch: Self.default.whatsNewOnLaunch
        )
    }
}

// MARK: with functions
extension GlobalSettings {
    public func with(selectedComponents: Set<WeatherChartComponent>) -> Self {
        let newMapping = Dictionary(uniqueKeysWithValues: WeatherChartComponent.allCases.map {
            ($0, selectedComponents.contains($0))
        })

        return with(\.shownComponents, value: newMapping)
    }
}
