import Foundation
import WhatToWearCommonCore

// MARK: DailyForecast
public struct DailyForecast {
    internal let internalData: NonEmptyArray<DailyData>

    public var data: DailyData { return internalData.first }
}

// MARK: Codable
extension DailyForecast: Codable {
    // MARK: CodingKeys
    public enum CodingKeys: String, ContainerCodingKey {
        case internalData = "data"
    }
}

// MARK: Equatable
extension DailyForecast: Equatable {}
