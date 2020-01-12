import Foundation
import WhatToWearCommonModels

public protocol BasicConditionProtocol {
    func isMetBy(dataPoint: HourlyDataPoint, for forecast: Forecast) -> Bool
}
