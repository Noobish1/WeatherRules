import Foundation
import WhatToWearModels

internal final class GlobalSettingsMigrator: MigratorProtocol {
    // MARK: typealiases
    internal typealias Object = GlobalSettings
    
    // MARK: migration
    internal func migrationToNextVersion(from version: GlobalSettingsVersion) -> Migration {
        switch version {
            case .initial:
                return .custom({ data in
                    let decoder = JSONDecoder()
                    let encoder = JSONEncoder()

                    guard let oldSettings = try? decoder.decode(OldGlobalSettings.self, from: data) else {
                        let oldSettings = try decoder.decode(
                            PreComponentsGlobalSettings.self, from: data
                        )

                        let newSettings = PreBackgroundsGlobalSettings(
                            measurementSystem: oldSettings.measurementSystem,
                            shownComponents: WeatherChartComponent.defaultMapping
                        )

                        return try encoder.encode(newSettings)
                    }

                    let shownComponents: [(WeatherChartComponent, Bool)] = WeatherChartComponent.allCases.map { component in
                        guard case .initial = component.versionWhenAdded else {
                            return (component, component.shownByDefault)
                        }

                        return (component, oldSettings.shownComponents.contains(component))
                    }

                    let newSettings = PreBackgroundsGlobalSettings(
                        measurementSystem: oldSettings.measurementSystem,
                        shownComponents: Dictionary(uniqueKeysWithValues: shownComponents)
                    )

                    return try encoder.encode(newSettings)
                })
            case .rulesSetToRulesDict:
                return .simple(from: PreBackgroundsGlobalSettings.self, to: PreUpdatesGlobalSettings.self)
            case .addedBackgrounds:
                return .simple(from: PreUpdatesGlobalSettings.self, to: PreWhatsNewGlobalSettings.self)
            case .addedUpdates:
                return .simple(from: PreWhatsNewGlobalSettings.self, to: PreExtraConfigGlobalSettings.self)
            case .addedWhatsNew:
                return .simple(from: PreExtraConfigGlobalSettings.self, to: GlobalSettings.self)
            case .addedExtraConfig:
                return .noMigrationRequired()
        }
    }
}
