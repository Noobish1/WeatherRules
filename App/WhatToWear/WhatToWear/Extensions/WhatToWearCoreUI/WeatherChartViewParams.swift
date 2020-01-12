import CoreLocation
import WhatToWearAssets
import WhatToWearCommonModels
import WhatToWearCoreUI
import WhatToWearModels

extension WeatherChartView.Params {
    internal static func legendParams(settings: GlobalSettings) -> WeatherChartView.Params {
        guard let jsonURL = R.file.legendJson() else {
            fatalError("Could not find path for legend.json")
        }

        do {
            let data = try Data(contentsOf: jsonURL)
            let forecast = try JSONDecoder().decode(Forecast.self, from: data)
            let day = forecast.hourly.data.first.time

            return WeatherChartView.Params(
                day: day,
                currentTime: day.addingTimeInterval(12.hours),
                forecast: TimedForecast(forecast: forecast, timestamp: .now),
                location: ValidLocation(
                    // Maungaraki Latitude/Longitude
                    location: CLLocation(latitude: -41.2038797, longitude: 174.8768859)
                ),
                settings: settings
            )
        } catch let error {
            fatalError("attempting to load forecast from legend.json failed with error: \(error)")
        }
    }
}
