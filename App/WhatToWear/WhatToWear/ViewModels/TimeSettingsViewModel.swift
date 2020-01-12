import Foundation
import WhatToWearModels

internal enum TimeSettingsViewModel {
    internal static func title(for timeSettings: TimeSettings, timeZone: TimeZone) -> String {
        let intervalPart = TimeSettingsIntervalViewModel.shortTitle(for: timeSettings.interval)
        let timeRangePart = TimeRangeViewModel.completeTitle(for: timeSettings.timeRange, timeZone: timeZone)

        return "\(intervalPart)\(String.nbsp)\u{FFED}\(String.nbsp)\(timeRangePart)"
    }
}
