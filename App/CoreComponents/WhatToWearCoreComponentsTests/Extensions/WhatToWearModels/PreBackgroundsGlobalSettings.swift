import Foundation
import WhatToWearModels
import WhatToWearCore
import WhatToWearCommonCore

extension PreBackgroundsGlobalSettings {
    internal enum wtw: WTWRandomizer {
        public static func random() -> PreBackgroundsGlobalSettings {
            return PreBackgroundsGlobalSettings(
                measurementSystem: MeasurementSystem.wtw.random(),
                shownComponents: Dictionary(
                    uniqueKeysWithValues: WeatherChartComponent.nonEmptyCases.map {
                        ($0, Bool.random())
                    }
                )
            )
        }
    }
}
