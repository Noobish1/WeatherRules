import Foundation
import WhatToWearCore
import WhatToWearModels

internal struct ForecastRequest: Codable, Hashable {
    // MARK: properties
    internal let dateParams: DateParams
    internal let location: ValidLocation
    internal let params: ForecastParameters

    // MARK: init
    internal init(date: Date, location: ValidLocation, timeZone: TimeZone, params: ForecastParameters) {
        self.dateParams = DateParams(date: date, timeZone: timeZone)
        self.location = location
        self.params = params
    }
}
