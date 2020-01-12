import Foundation
import WhatToWearCharts
import WhatToWearCommonCore
import WhatToWearCommonModels
import WhatToWearCore
import WhatToWearModels

internal enum PrecipitationDataSetFactory {
    // MARK: making dataSets
    internal static func makePrecipLineDataSet(
        data: PrecipitationData,
        viewModel: WeatherChartComponentViewModel
    ) -> LineChartDataSet {
        return LineChartDataSet(
            values: data.precipEntries,
            axisDependency: .right,
            isVisible: viewModel.isVisible,
            lineConfig: .init(
                mode: .linear(colors: data.lineColorEntries),
                capType: .round,
                width: 1
            )
        )
    }
    
    internal static func makeRainDataSet(
        data: PrecipitationData,
        viewModel: WeatherChartComponentViewModel
    ) -> LineChartDataSet {
        return makeFilledDataSet(data: data, viewModel: viewModel, precipType: .rain)
    }
    
    internal static func makeSleetDataSet(
        data: PrecipitationData,
        viewModel: WeatherChartComponentViewModel
    ) -> LineChartDataSet {
        return makeFilledDataSet(data: data, viewModel: viewModel, precipType: .sleet)
    }
    
    internal static func makeSnowDataSet(
        data: PrecipitationData,
        viewModel: WeatherChartComponentViewModel
    ) -> LineChartDataSet {
        return makeFilledDataSet(data: data, viewModel: viewModel, precipType: .snow)
    }
    
    private static func makeFilledDataSet(
        data: PrecipitationData,
        viewModel: WeatherChartComponentViewModel,
        precipType: PrecipitationType
    ) -> LineChartDataSet {
        let entries = data.entries(for: precipType)
        
        return LineChartDataSet(
            values: entries,
            axisDependency: .right,
            isVisible: viewModel.isVisible,
            lineConfig: .init(
                mode: .linear(colors: entries.map { _ in .clear }),
                capType: .round,
                width: 1
            ),
            fillConfig: .init(
                type: .color(data.color(for: precipType).cgColor),
                alpha: viewModel.fillAlpha,
                formatter: PercentageFillFormatter(flipped: false)
            )
        )
    }
}
