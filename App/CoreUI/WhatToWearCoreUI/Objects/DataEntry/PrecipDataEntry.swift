import Foundation
import WhatToWearCommonModels

internal struct PrecipDataEntry {
    // MARK: properties
    internal let point: CGPoint
    internal let accumulation: Double
    internal let precipType: PrecipitationType?

    // MARK: init
    internal init(dataPoint: HourlyDataPoint) {
        self.precipType = dataPoint.precipitationType
        self.accumulation = Self.accumulation(from: dataPoint)
        self.point = WeatherDataEntryFactory.makeEntry(
            time: dataPoint.time, value: CGFloat(dataPoint.chanceOfPrecipitation?.rawValue ?? 0)
        )
    }
    
    // MARK: static init helpers
    private static func accumulation(from dataPoint: HourlyDataPoint) -> Double {
        switch dataPoint.precipitationType {
            case .none: return 0
            case .rain, .sleet: return dataPoint.precipIntensity?.value ?? 0
            case .snow: return dataPoint.precipAccumulation?.value ?? 0
        }
    }
}
