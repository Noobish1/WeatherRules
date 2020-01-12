import Foundation
import WhatToWearCore
import WhatToWearModels
import WhatToWearCommonCore

extension PreExtraConfigGlobalSettings: WTWRandomized {
    public enum wtw: WTWRandomizer {
        public static func random() -> PreExtraConfigGlobalSettings {
            return PreExtraConfigGlobalSettings(
                measurementSystem: MeasurementSystem.wtw.random(),
                shownComponents: Dictionary(
                    uniqueKeysWithValues: WeatherChartComponent.nonEmptyCases.map {
                        ($0, Bool.random())
                    }
                ),
                appBackgroundOptions: AppBackgroundOptions.wtw.random(),
                lastSeenUpdate: Bool.random() ? nil : try! LatestAppUpdate.fixtures.valid.object(),
                lastUpdateAvailable: Bool.random() ? nil : try! LatestAppUpdate.fixtures.valid.object(),
                lastWhatsNewVersionSeen: OperatingSystemVersion.wtw.random()
            )
        }
    }
}
