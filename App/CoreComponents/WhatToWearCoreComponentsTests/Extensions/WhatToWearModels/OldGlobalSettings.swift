import Foundation
import WhatToWearModels
import WhatToWearCore
import WhatToWearCommonCore

extension OldGlobalSettings: WTWRandomized {
    public enum wtw: WTWRandomizer {
        public static func random() -> OldGlobalSettings {
            return OldGlobalSettings(
                measurementSystem: MeasurementSystem.wtw.random(),
                shownComponents: Set(WeatherChartComponent.nonEmptyCases.randomSubArray())
            )
        }
    }
}
