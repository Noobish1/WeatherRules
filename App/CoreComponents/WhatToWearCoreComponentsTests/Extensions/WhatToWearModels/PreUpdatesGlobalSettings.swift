import Foundation
import WhatToWearModels
import WhatToWearCore
import WhatToWearCommonCore

extension PreUpdatesGlobalSettings {
    internal enum wtw: WTWRandomizer {
        public static func random() -> PreUpdatesGlobalSettings {
            return PreUpdatesGlobalSettings(
                measurementSystem: MeasurementSystem.wtw.random(),
                shownComponents: Dictionary(
                    uniqueKeysWithValues: WeatherChartComponent.nonEmptyCases.map {
                        ($0, Bool.random())
                    }
                ),
                appBackgroundOptions: AppBackgroundOptions.wtw.random()
            )
        }
    }
}
