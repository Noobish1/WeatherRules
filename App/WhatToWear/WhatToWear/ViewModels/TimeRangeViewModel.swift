import Foundation
import WhatToWearCore
import WhatToWearModels

internal enum TimeRangeViewModel: TimeRangeViewModelProtocol {
    internal static func analyticsValue(for timeRange: TimeRange, timeZone: TimeZone) -> String {
        return completeTitle(for: timeRange, timeZone: timeZone)
    }
    
    internal static func completeTitle(for timeRange: TimeRange, timeZone: TimeZone) -> String {
        let from = fromTitle(for: timeRange, timeZone: timeZone)
        let to = toTitle(for: timeRange, timeZone: timeZone)

        return "\(from)\(String.nbhypen)\(to)"
    }
}
