import CoreLocation
import Foundation
import WhatToWearCharts
import WhatToWearCore
import WhatToWearModels

internal enum SunAltitudeDataSetFactory {
    // MARK: init
    internal static func makeDataSet(
        data: SunAltitudeData,
        viewModel: WeatherChartComponentViewModel
    ) -> LineChartDataSet {
        return LineChartDataSet(
            values: data.entries,
            axisDependency: .right,
            isVisible: viewModel.isVisible,
            lineConfig: .init(
                mode: .linear(colors: data.entries.map { _ in viewModel.color }),
                capType: .round,
                width: 3
            )
        )
    }
}
