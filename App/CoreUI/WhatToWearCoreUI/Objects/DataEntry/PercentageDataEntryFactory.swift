import Foundation
import Tagged
import WhatToWearCommonModels
import WhatToWearCore
import WhatToWearModels

internal enum PercentageDataEntryFactory {
    internal static func makeEntry(
        chartValue: ValidChartValue<Percentage<Double>>,
        flipped: Bool
    ) -> CGPoint {
        let clampedValue: CGFloat

        if flipped {
            clampedValue = 1 - CGFloat(chartValue.value.rawValue).clamped(to: 0...1)
        } else {
            clampedValue = CGFloat(chartValue.value.rawValue).clamped(to: 0...1)
        }

        // We don't normalize this because we always have a percentage right axis
        
        return WeatherDataEntryFactory.makeEntry(time: chartValue.time, value: clampedValue)
    }
}
