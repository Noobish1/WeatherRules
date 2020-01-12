import Foundation
import WhatToWearCommonModels

public struct TimedForecast: Codable, Equatable {
    // MARK: properties
    public let id: UUID?
    public let forecast: Forecast
    public let timestamp: Seconds<Double>

    // MARK: init
    public init(id: UUID? = nil, forecast: Forecast, timestamp: Date) {
        self.id = id
        self.forecast = forecast
        self.timestamp = Seconds(rawValue: timestamp.timeIntervalSince1970)
    }
}
