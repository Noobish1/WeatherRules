import Foundation
import WhatToWearCharts
import WhatToWearCommonCore
import WhatToWearCommonModels
import WhatToWearCore
import WhatToWearModels

internal struct WindGustData {
    // MARK: properties
    internal let range: ClosedRange<CGFloat>
    internal let chartEntries: NonEmptyArray<CGPoint>
    internal let windEntries: NonEmptyArray<WindDataEntry>

    // MARK: init
    internal init(dataPoints: NonEmptyArray<HourlyDataPoint>, windType: WindType) {
        let entries = dataPoints.map { WindDataEntry(dataPoint: $0, windType: windType) }
        let yValues = entries.map { $0.point.y }

        let roundedMaxYValue = yValues.max().roundUp(toNumberOfDecimalPlaces: 0)
        let roundedMinYValue = yValues.min().roundDown(toNumberOfDecimalPlaces: 0)

        self.range = roundedMinYValue...roundedMaxYValue

        // We use the unrounded entries because these are plotted
        self.chartEntries = entries.map { $0.point }
        self.windEntries = entries
    }
}
