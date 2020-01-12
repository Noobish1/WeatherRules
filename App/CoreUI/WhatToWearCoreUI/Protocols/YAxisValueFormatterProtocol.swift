import Foundation
import WhatToWearCharts

// MARK: YAxisValueFormatterProtocol
internal protocol YAxisValueFormatterProtocol: AxisValueFormatterProtocol {
    associatedtype DimensionType: Dimension
    
    var rawUnit: DimensionType { get }
    var displayedUnit: DimensionType { get }
    var formatter: MeasurementFormatter { get }
}

// MARK: AxisValueFormatterProtocol
extension YAxisValueFormatterProtocol {
    internal func stringForValue(_ value: CGFloat) -> String {
        let measurement = Measurement(value: Double(value), unit: rawUnit)
        let displayedMeasurement = measurement.converted(to: displayedUnit)
        
        return formatter.string(from: displayedMeasurement)
    }
}
