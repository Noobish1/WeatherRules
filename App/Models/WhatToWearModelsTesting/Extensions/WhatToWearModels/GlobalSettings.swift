import Foundation
import WhatToWearCore
import WhatToWearModels
import WhatToWearCommonCore

extension GlobalSettings: WTWRandomized {
    public enum wtw: WTWRandomizer {
        public static func random() -> GlobalSettings {
            return GlobalSettings(
                measurementSystem: MeasurementSystem.wtw.random(),
                shownComponents: Dictionary(
                    uniqueKeysWithValues: WeatherChartComponent.nonEmptyCases.map {
                        ($0, Bool.random())
                    }
                ),
                appBackgroundOptions: AppBackgroundOptions.wtw.random(),
                lastSeenUpdate: Bool.random() ? nil : try! LatestAppUpdate.fixtures.valid.object(),
                lastUpdateAvailable: Bool.random() ? nil : try! LatestAppUpdate.fixtures.valid.object(),
                lastWhatsNewVersionSeen: OperatingSystemVersion.wtw.random(),
                temperatureType: TemperatureType.nonEmptyCases.randomElement(),
                windType: WindType.nonEmptyCases.randomElement(),
                whatsNewOnLaunch: Bool.random()
            )
        }
    }
}
