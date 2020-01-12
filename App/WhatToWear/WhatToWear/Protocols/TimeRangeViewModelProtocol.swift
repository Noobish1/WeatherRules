import Foundation
import WhatToWearModels

// MARK: TimeRangeViewModelProtocol
internal protocol TimeRangeViewModelProtocol {}

// MARK: extensions
extension TimeRangeViewModelProtocol {
    // MARK: static init helpers
    internal static func fromTitle(for timeRange: TimeRange, timeZone: TimeZone) -> String {
        return MilitaryTimeViewModel.displayedString(for: timeRange.start, timeZone: timeZone)
    }
    
    internal static func toTitle(for timeRange: TimeRange, timeZone: TimeZone) -> String {
        return MilitaryTimeViewModel.displayedString(for: timeRange.end, timeZone: timeZone)
    }
}
