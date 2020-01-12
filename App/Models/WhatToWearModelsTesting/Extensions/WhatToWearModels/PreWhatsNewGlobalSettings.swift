import Foundation
import WhatToWearModels
import WhatToWearCore
import WhatToWearCommonCore

extension PreWhatsNewGlobalSettings: WTWRandomized {
    public enum wtw: WTWRandomizer {
        public static func random() -> PreWhatsNewGlobalSettings {
            return PreWhatsNewGlobalSettings(
                measurementSystem: MeasurementSystem.wtw.random(),
                shownComponents: Dictionary(
                    uniqueKeysWithValues: WeatherChartComponent.nonEmptyCases.map {
                        ($0, Bool.random())
                    }
                ),
                appBackgroundOptions: AppBackgroundOptions.wtw.random(),
                lastSeenUpdate: Bool.random() ? nil : try! LatestAppUpdate.fixtures.valid.object(),
                lastUpdateAvailable: Bool.random() ? nil : try! LatestAppUpdate.fixtures.valid.object()
            )
        }
    }
}
