import Foundation
import WhatToWearModels

// MARK: ForecastStore
public struct ForecastStore: Codable {
    // MARK: properties
    internal var forecasts: [ForecastRequest: TimedForecast]

    // MARK: init
    internal init(forecasts: [ForecastRequest: TimedForecast] = [:]) {
        self.forecasts = forecasts
    }

    // MARK: removing forecasts
    internal mutating func filterForecastsOutside(window: ForecastWindow) {
        forecasts = forecasts.filter { request, _ -> Bool in
            window.contains(dateParams: request.dateParams)
        }
    }
}

// MARK: DefaultsBackedObject
extension ForecastStore: DefaultsBackedObject {
    public typealias Version = ForecastStoreVersion
}

// MARK: DefaultsBackedObjectWithNonNilDefault
extension ForecastStore: DefaultsBackedObjectWithNonNilDefault {
    public static var `default`: Self {
        return ForecastStore()
    }
}
