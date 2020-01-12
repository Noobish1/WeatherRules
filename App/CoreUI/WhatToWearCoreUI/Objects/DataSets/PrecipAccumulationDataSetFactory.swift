import WhatToWearCharts
import WhatToWearModels

internal enum PrecipAccumulationDataSetFactory {
    // MARK: init
    internal static func makeDataSet(
        data: PrecipitationData,
        viewModel: WeatherChartComponentViewModel,
        system: MeasurementSystem
    ) -> ScatterChartDataSet {
        let formatter = PrecipAccumulationValueFormatter(
            data: data, system: system
        )
        
        return ScatterChartDataSet(
            values: data.precipEntries,
            axisDependency: .right,
            valueConfig: .init(
                formatter: formatter,
                font: .systemFont(ofSize: 11),
                textColorConfig: .formatter(formatter),
                shadow: NSShadow().then {
                    $0.shadowColor = UIColor.white.darker(by: 45.percent)
                    $0.shadowOffset = CGSize(width: 0, height: 1)
                    $0.shadowBlurRadius = 0
                }
            ),
            isVisible: viewModel.isVisible,
            scatterConfig: nil
        )
    }
}
