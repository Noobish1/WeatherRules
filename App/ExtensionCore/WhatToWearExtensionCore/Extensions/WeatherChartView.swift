import Foundation
import WhatToWearCoreUI

extension WeatherChartView.Params {
    public init(params: ForecastLoadingParams) {
        self.init(
            day: params.date,
            currentTime: .now,
            forecast: params.timedForecast,
            location: params.location,
            settings: params.settings
        )
    }
}
