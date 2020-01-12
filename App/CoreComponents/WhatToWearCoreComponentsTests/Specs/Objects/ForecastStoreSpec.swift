import Quick
import Nimble
import WhatToWearModels
import WhatToWearModels
@testable import WhatToWearCoreComponents
import WhatToWearCommonModels

internal final class ForecastStoreSpec: QuickSpec {
    internal override func spec() {
        describe("ForecastStore") {
            describe("its filterForecastsOutside window") {
                var calendar: Calendar!
                var date: Date!
                var store: ForecastStore!

                beforeEach {
                    calendar = Calendar.current
                    date = Date.wtw.random()
                }

                context("when the store contains one forecast that is within the window") {
                    beforeEach {
                        let interval = abs(
                            ForecastWindow.Distance.inThePast.rawValue -
                            ForecastWindow.Distance.inTheFuture.rawValue
                        )
                        let middleDate = calendar.date(
                            byAdding: .day,
                            value: (ForecastWindow.Distance.inThePast.rawValue + interval/2),
                            to: date
                        )!
                        let window = ForecastWindow.around(date: date, timeZone: .current)
                        let cachedForecast = TimedForecast(
                            forecast: try! Forecast.fixtures.valid.object(),
                            timestamp: Date.wtw.random()
                        )
                        let request = ForecastRequest(
                            date: middleDate,
                            location: ValidLocation.random(),
                            timeZone: .current,
                            params: ForecastParameters()
                        )
                        store = ForecastStore(forecasts: [request: cachedForecast])
                        store.filterForecastsOutside(window: window)
                    }

                    it("should not remove any forecasts") {
                        expect(store.forecasts).toNot(beEmpty())
                    }
                }

                context("when the store contains one forecast that is outside the window") {
                    beforeEach {
                        let pastDate = calendar.date(
                            byAdding: .day,
                            value: (ForecastWindow.Distance.inThePast.rawValue -  Int.random(in: 1...10)),
                            to: date
                        )!
                        let window = ForecastWindow.around(date: date, timeZone: .current)
                        let cachedForecast = TimedForecast(
                            forecast: try! Forecast.fixtures.valid.object(),
                            timestamp: Date.wtw.random()
                        )
                        let request = ForecastRequest(
                            date: pastDate,
                            location: ValidLocation.random(),
                            timeZone: .current,
                            params: ForecastParameters()
                        )
                        store = ForecastStore(forecasts: [request: cachedForecast])
                        store.filterForecastsOutside(window: window)
                    }

                    it("should not remove the forecast") {
                        expect(store.forecasts).to(beEmpty())
                    }
                }
            }
        }
    }
}
