import ErrorRecorder
import Foundation
import Moya
import RxSwift
import WhatToWearCommonModels
import WhatToWearCore
import WhatToWearCoreComponents
import WhatToWearModels

public final class DarkSkyClient {
    // MARK: properties
    private let darkSkyProvider = MoyaProvider<DarkSkyService>()
    private let forecastController = ForecastController()

    // MARK: init
    public init() {}

    // MARK: API calls
    public func forecast(date: Date, location: ValidLocation) -> Single<TimedForecast> {
        let timestamp = Date.now

        return darkSkyProvider.rx
            .request(.forecast(date: date, location: location))
            .map(Forecast.self)
            .map { TimedForecast(forecast: $0, timestamp: timestamp) }
            .do(onSuccess: { [forecastController] forecast in
                forecastController.cache(forecast: forecast, for: date, location: location)

                Analytics.record(event: .forecastRequest)
            }, onError: { error in
                let ourError = WTWError(
                    format: "Forecast request failed with error",
                    arguments: [error.localizedDescription]
                )

                ErrorRecorder.record(ourError)
            })
    }
}
