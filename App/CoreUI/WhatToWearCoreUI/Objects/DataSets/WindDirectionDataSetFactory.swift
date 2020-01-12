import Foundation
import Then
import WhatToWearCharts
import WhatToWearCore
import WhatToWearModels

internal enum WindDirectionDataSetFactory {
    // MARK: init
    internal static func makeDataSet(
        data: WindGustData,
        viewModel: WeatherChartComponentViewModel
    ) -> ScatterChartDataSet {
        return ScatterChartDataSet(
            values: data.chartEntries,
            axisDependency: .left,
            valueConfig: .init(
                formatter: WindBearingValueFormatter(windDataEntries: data.windEntries),
                font: .systemFont(ofSize: 20),
                textColorConfig: .single(viewModel.color),
                shadow: NSShadow().then {
                    $0.shadowColor = UIColor.white.darker(by: 80.percent)
                    $0.shadowOffset = CGSize(width: 0, height: 1)
                    $0.shadowBlurRadius = 0
                }
            ),
            isVisible: viewModel.isVisible,
            scatterConfig: nil
        )
    }
}
