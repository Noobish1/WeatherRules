import Foundation
import WhatToWearCommonModels

public protocol BasicDoubleMeasurementProtocol: BasicMeasurementProtocol {
    var rawRange: ClosedRange<Double> { get }

    func rawValue(forDisplayedValue displayedValue: DisplayedValue) -> Double
    func value(for dataPoint: HourlyDataPoint, in forecast: Forecast) -> Double?
}
