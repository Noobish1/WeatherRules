import Foundation
import WhatToWearCharts

// MARK: PercentageFillFormatter
internal final class PercentageFillFormatter {
    // MARK: properties
    private let flipped: Bool

    // MARK: init
    internal init(flipped: Bool) {
        self.flipped = flipped
    }
}

// MARK: FillFormatterProtocol
extension PercentageFillFormatter: FillFormatterProtocol {
    internal func fillLinePosition(
        dataSet: LineChartDataSet,
        dataProvider: DataProvider<LineChartDataSet>
    ) -> CGFloat {
        let axisRange = dataProvider.axisRange(forDataSet: dataSet)

        if flipped {
            return axisRange.upperBound
        } else {
            return axisRange.lowerBound
        }
    }
}
