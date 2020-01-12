import Foundation
import WhatToWearCharts

internal enum WeatherDataEntryFactory {
    // MARK: init
    internal static func makeEntry(time: Date, value: CGFloat) -> CGPoint {
        // We bump the time by 30 minutes in order to make the values in the center of the hour interval
        return CGPoint(x: CGFloat(time.timeIntervalSince1970 + 30.minutes), y: value)
    }
}
