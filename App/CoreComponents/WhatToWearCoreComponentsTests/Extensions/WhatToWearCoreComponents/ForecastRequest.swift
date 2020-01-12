@testable import WhatToWearCoreComponents
import WhatToWearModels

extension ForecastRequest {
    internal static func random(date: Date, timeZone: TimeZone) -> ForecastRequest {
        return ForecastRequest(
            date: date,
            location: ValidLocation.random(),
            timeZone: timeZone,
            params: ForecastParameters()
        )
    }
}
