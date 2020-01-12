import Foundation
import WhatToWearCharts
import WhatToWearCommonCore
import WhatToWearCommonModels
import WhatToWearCore
import WhatToWearModels

internal enum HumidityDataSetFactory {
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
                width: 3
            ),
            fillConfig: nil,
            keypath: \.humidity,
            flipped: false,
            isVisible: viewModel.isVisible
        )
    }
}
