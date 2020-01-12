import ErrorRecorder
import Foundation
import WhatToWearCoreComponents
import WhatToWearModels

internal final class MutableTimeSettingsViewModel {
    // MARK: properties
    internal var timeSettings: TimeSettings
    
    // MARK: init
    internal init(timeSettings: TimeSettings) {
        self.timeSettings = timeSettings
    }
    
    // MARK: timerange info alert
    internal func timeRangeInfoAlertTitle() -> String {
        return NSLocalizedString("Time Range", comment: "")
    }
    
    internal func timeRangeInfoAlertMessage() -> String {
        return NSLocalizedString(
        """
            Your rules will only be evaluated within this time range.

            Note: Rules can have their own time ranges also.
        """, comment: ""
        )
    }
    
    // MARK: interval info alert
    internal func intervalInfoAlertTitle() -> String {
        return NSLocalizedString("Intervals", comment: "")
    }
    
    internal func intervalInfoAlertMessage() -> String {
        return TimeSettings.Interval.nonEmptyCases
            .map(TimeSettingsIntervalInfoViewModel.init)
            .map { $0.title }
            .joined(separator: "\n\n")
            .appending(NSLocalizedString(
                "\n\nNote: Rules can have their own time ranges also.",
                comment: ""
            ))
    }
    
    // MARK: update
    internal func updateTimeSettings(with interval: TimeSettings.Interval) {
        let newSettings = timeSettings.with(\.interval, value: interval)

        update(timeSettings: newSettings)

        Analytics.record(event: .timeSettingsIntervalChanged(interval.analyticsValue))
    }

    internal func updateTimeSettings(with timeRange: TimeRange) {
        let newSettings = timeSettings.with(\.timeRange, value: timeRange)

        update(timeSettings: newSettings)

        let title = TimeRangeViewModel.analyticsValue(for: timeRange, timeZone: .current)
        
        Analytics.record(event: .timeSettingsTimeRangeChanged(title))
    }

    private func update(timeSettings: TimeSettings) {
        self.timeSettings = timeSettings
        
        TimeSettingsController.shared.save(timeSettings)
    }
}
