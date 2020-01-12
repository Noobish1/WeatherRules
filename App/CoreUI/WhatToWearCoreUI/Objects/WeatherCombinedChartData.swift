import Foundation
import WhatToWearCharts
import WhatToWearCommonCore
import WhatToWearCommonModels
import WhatToWearCore
import WhatToWearModels

internal final class WeatherCombinedChartData {
    // MARK: properties
    internal let temperatureRange: ClosedRange<CGFloat>
    internal let windRange: ClosedRange<CGFloat>
    internal let dataSets: NonEmptyArray<CombinedChartDataSet>

    // MARK: init
    internal init(chartParams: WeatherChartView.Params, context: WeatherChartView.Context) {
        let dataPoints = chartParams.forecast.forecast.hourly.data
        let windGustData = WindGustData(dataPoints: dataPoints, windType: chartParams.settings.windType)

        let windGustDataSet = WindGustDataSetFactory.makeDataSet(
            data: windGustData,
            viewModel: WeatherChartComponentViewModel(component: .windGust, componentsToShow: chartParams.componentsToShow)
        )

        self.windRange = windGustData.range

        let windDirectionDataSet = WindDirectionDataSetFactory.makeDataSet(
            data: windGustData,
            viewModel: WeatherChartComponentViewModel(component: .windDirection, componentsToShow: chartParams.componentsToShow)
        )

        let temperatureDataSet = TemperatureDataSet(
            dataPoints: dataPoints,
            temperatureType: chartParams.settings.temperatureType,
            viewModel: WeatherChartComponentViewModel(component: .temperature, componentsToShow: chartParams.componentsToShow)
        )
        
        self.temperatureRange = temperatureDataSet.temperatureRange

        let sunData = SunAltitudeData(dataPoints: dataPoints, location: chartParams.location)

        let sunAltitudeDataSet = SunAltitudeDataSetFactory.makeDataSet(
            data: sunData,
            viewModel: WeatherChartComponentViewModel(component: .sunAltitude, componentsToShow: chartParams.componentsToShow)
        )
        let sunDataSet = SunDataSet(
            data: sunData,
            viewModel: WeatherChartComponentViewModel(component: .solarNoon, componentsToShow: chartParams.componentsToShow),
            context: context
        )
        
        let precipData = PrecipitationData(dataPoints: dataPoints, chartStyle: .linear)
        
        let precipAccumulationDataSet = PrecipAccumulationDataSetFactory.makeDataSet(
            data: precipData,
            viewModel: WeatherChartComponentViewModel(
                component: .precipAccumulation, componentsToShow: chartParams.componentsToShow
            ),
            system: chartParams.settings.measurementSystem
        )
        
        let precipLineDataSet = PrecipitationDataSetFactory.makePrecipLineDataSet(
            data: precipData,
            viewModel: WeatherChartComponentViewModel(
                component: .chanceOfPrecip, componentsToShow: chartParams.componentsToShow
            )
        )
        
        let rainDataSet = PrecipitationDataSetFactory.makeRainDataSet(
            data: precipData,
            viewModel: WeatherChartComponentViewModel(
                component: .chanceOfPrecip, componentsToShow: chartParams.componentsToShow
            )
        )
        
        let sleetDataSet = PrecipitationDataSetFactory.makeSleetDataSet(
            data: precipData,
            viewModel: WeatherChartComponentViewModel(
                component: .chanceOfPrecip, componentsToShow: chartParams.componentsToShow
            )
        )
        
        let snowDataSet = PrecipitationDataSetFactory.makeSnowDataSet(
            data: precipData,
            viewModel: WeatherChartComponentViewModel(
                component: .chanceOfPrecip, componentsToShow: chartParams.componentsToShow
            )
        )
        
        let cloudCoverDataSet = CloudCoverDataSetFactory.makeDataSet(
            dataPoints: dataPoints,
            viewModel: WeatherChartComponentViewModel(component: .cloudCover, componentsToShow: chartParams.componentsToShow)
        )
        let humidityDataSet = HumidityDataSetFactory.makeDataSet(
            dataPoints: dataPoints,
            viewModel: WeatherChartComponentViewModel(component: .humidity, componentsToShow: chartParams.componentsToShow)
        )
        let nowDataSet = NowDataSetFactory.makeDataSet(
            currentTime: chartParams.currentTime,
            dataPoints: dataPoints,
            viewModel: WeatherChartComponentViewModel(component: .currentTime, componentsToShow: chartParams.componentsToShow)
        )

        let rest = [
            CombinedChartDataSet(sunDataSet.scatterDataSet),
            CombinedChartDataSet(cloudCoverDataSet), CombinedChartDataSet(precipLineDataSet), CombinedChartDataSet(rainDataSet),
            CombinedChartDataSet(sleetDataSet), CombinedChartDataSet(snowDataSet),
            CombinedChartDataSet(precipAccumulationDataSet), CombinedChartDataSet(humidityDataSet),
            CombinedChartDataSet(windGustDataSet), CombinedChartDataSet(windDirectionDataSet),
            CombinedChartDataSet(temperatureDataSet.lineDataSet), CombinedChartDataSet(nowDataSet)
        ]

        self.dataSets = NonEmptyArray(
            firstElement: .line(sunAltitudeDataSet), rest: rest.compactMap { $0 }
        )
    }
}
