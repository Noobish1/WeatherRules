import Foundation
import WhatToWearCommonCore

// MARK: PrecipitationType
public enum PrecipitationType: String, Codable, CaseIterable {
    case rain = "rain"
    case snow = "snow"
    case sleet = "sleet"
}
