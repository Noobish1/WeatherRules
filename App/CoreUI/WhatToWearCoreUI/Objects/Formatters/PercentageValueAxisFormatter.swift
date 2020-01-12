import Foundation
import WhatToWearCharts

internal final class PercentageValueAxisFormatter: AxisValueFormatterProtocol {
    internal func stringForValue(_ value: CGFloat) -> String {
        let endValue = Int((value * 100).roundUp(toNumberOfDecimalPlaces: 0))
        
        return "\(endValue)%"
    }
}
