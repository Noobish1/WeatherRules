import Foundation
import WhatToWearCharts
import WhatToWearCommonCore
import WhatToWearCommonModels
import WhatToWearCore
import WhatToWearModels

internal struct TemperatureDataSet {
    // MARK: properties
    internal let temperatureRange: ClosedRange<CGFloat>
    internal let lineDataSet: LineChartDataSet

    // MARK: init
    internal init(
        dataPoints: NonEmptyArray<HourlyDataPoint>,
        temperatureType: TemperatureType,
        viewModel: WeatherChartComponentViewModel
    ) {
        let entries = dataPoints.map {
            WeatherDataEntryFactory.makeEntry(
                time: $0.time, value: CGFloat($0[keyPath: temperatureType.dataPointKeyPath].value)
            )
        }
        let yValues = entries.map { $0.y }
        
        let roundedMaxYValue = yValues.max().roundUp(toNumberOfDecimalPlaces: 0)
        let roundedMinYValue = yValues.min().roundDown(toNumberOfDecimalPlaces: 0)

        self.temperatureRange = roundedMinYValue...roundedMaxYValue

        self.lineDataSet = LineChartDataSet(
            values: entries,
            axisDependency: .left,
            isVisible: viewModel.isVisible,
            lineConfig: .init(
                mode: .cubicBezier(color: viewModel.color),
                capType: .round,
                width: 3
            )
        )
    }
}
