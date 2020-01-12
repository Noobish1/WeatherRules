import Foundation
import WhatToWearCharts
import WhatToWearCommonCore
import WhatToWearCommonModels
import WhatToWearCore
import WhatToWearModels

internal enum CloudCoverDataSetFactory {
    // MARK: init/deinit
    internal static func makeDataSet(
        dataPoints: NonEmptyArray<HourlyDataPoint>,
        viewModel: WeatherChartComponentViewModel
    ) -> LineChartDataSet? {
        return PercentageDataSetFactory.makeDataSet(
            dataPoints: dataPoints,
            axisDependency: .right,
            lineConfig: .init(
                mode: .cubicBezier(color: viewModel.color),
                capType: .round,
                width: 1
            ),
            fillConfig: .init(
                type: .color(viewModel.color.cgColor),
                alpha: viewModel.fillAlpha,
                formatter: PercentageFillFormatter(flipped: true)
            ),
            keypath: \.cloudCover,
            flipped: true,
            isVisible: viewModel.isVisible
        )
    }
}
