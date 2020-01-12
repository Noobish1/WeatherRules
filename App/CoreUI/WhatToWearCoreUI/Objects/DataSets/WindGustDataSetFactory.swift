import Foundation
import Then
import WhatToWearCharts
import WhatToWearCore
import WhatToWearModels

internal enum WindGustDataSetFactory {
    // MARK: init
    internal static func makeDataSet(
        data: WindGustData,
        viewModel: WeatherChartComponentViewModel
    ) -> LineChartDataSet {
        return LineChartDataSet(
            values: data.chartEntries,
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
