import Foundation
import WhatToWearCommonCore

// MARK: HourlyForecast
public struct HourlyForecast {
    public let data: NonEmptyArray<HourlyDataPoint>
}

// MARK: Codable
extension HourlyForecast: Codable {}

// MARK: Equatable
extension HourlyForecast: Equatable {}
