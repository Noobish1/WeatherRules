import Quick
import Nimble
import WhatToWearModels
import WhatToWearCommonModels
@testable import WhatToWearCoreComponents

private final class ThrowingForecastStoreMigrator: MigratorProtocol {
    fileprivate typealias Object = ForecastStore
    
    fileprivate func migrationToNextVersion(from version: ForecastStoreVersion) -> Migration {
        return .custom { _ -> Data in
            throw NSError(domain: "Unit test migration error", code: 0, userInfo: nil)
        }
    }
}

private final class EmptyForecastStoreMigrator: MigratorProtocol {
    fileprivate typealias Object = ForecastStore
    
    fileprivate func migrationToNextVersion(from version: ForecastStoreVersion) -> Migration {
        return .noMigrationRequired()
    }
}

internal final class ForecastControllerSpec: QuickSpec {
    internal override func spec() {
        describe("ForecastController") {
            describe("its init with no params") {
                var controller: ForecastController!

                beforeEach {
                    controller = ForecastController()
                }

                it("should call the other init with the forecats controllerconfig") {
                    // the userdefaults property will be different for each instance
                    expect(controller.config.objectKey) == ControllerConfig.forecasts.objectKey
                    expect(controller.config.objectVersionKey) == ControllerConfig.forecasts.objectVersionKey
                }
            }
            
            describe("its retrieveStore") {
                var forecastsSuiteName: String!
                var forecastsDefaults: UserDefaults!
                var timeZonesSuiteName: String!
                var timeZonesDefaults: UserDefaults!
                var timeZonesController: TimeZonesController!
                
                beforeEach {
                    forecastsSuiteName = String.wtw.random()
                    forecastsDefaults = UserDefaults(suiteName: forecastsSuiteName)!
                    timeZonesSuiteName = String.wtw.random()
                    timeZonesDefaults = UserDefaults(suiteName: timeZonesSuiteName)!
                    timeZonesController = TimeZonesController.random(defaults: timeZonesDefaults)
                }
                
                afterEach {
                    forecastsDefaults.removeSuite(named: forecastsSuiteName)
                    timeZonesDefaults.removeSuite(named: timeZonesSuiteName)
                }
                
                context("when the store can be retrieved") {
                    var expectedStore: ForecastStore!
                    var actualStore: ForecastStore!
                    
                    beforeEach {
                        let forecastController = ForecastController.random(
                            config: ControllerConfig.random(defaults: forecastsDefaults),
                            timeZonesController: timeZonesController
                        )
                        
                        let timedForecast = TimedForecast(
                            id: UUID(), forecast: try! Forecast.fixtures.valid.object(), timestamp: .now
                        )
                        
                        let date = Date.now
                        let location = ValidLocation.random()
                        
                        let request = ForecastRequest(date: date, location: location, timeZone: .current, params: ForecastParameters())
                        
                        expectedStore = ForecastStore(forecasts: [request: timedForecast])
                        
                        forecastController.save(expectedStore)
                        
                        actualStore = forecastController.retrieveStore()
                    }
                    
                    it("should return the store") {
                        expect(actualStore.forecasts.keys) == expectedStore.forecasts.keys
                        expect(actualStore.forecasts.values.map { $0.id }) == actualStore.forecasts.values.map { $0.id }
                    }
                }
                
                context("when the store cannot be retrieved due to an error") {
                    context("when the error is a migration error") {
                        var expectedStore: ForecastStore!
                        var actualStore: ForecastStore!
                        var storedStore: ForecastStore!
                        var controllerConfig: ControllerConfig!
                        
                        beforeEach {
                            controllerConfig = ControllerConfig.random(defaults: forecastsDefaults)
                            
                            let forecastController = ForecastController.random(
                                config: controllerConfig,
                                timeZonesController: timeZonesController,
                                migrator: AnyMigrator(ThrowingForecastStoreMigrator())
                            )
                            
                            // Save a random forecast store because we expect the default store back
                            let timedForecast = TimedForecast(
                                id: UUID(), forecast: try! Forecast.fixtures.valid.object(), timestamp: .now
                            )
                            
                            let date = Date.now
                            let location = ValidLocation.random()
                            
                            let request = ForecastRequest(date: date, location: location, timeZone: .current, params: ForecastParameters())
                            
                            let testStore = ForecastStore(forecasts: [request: timedForecast])
                            
                            forecastController.save(testStore)
                            
                            expectedStore = ForecastStore.default
                            actualStore = forecastController.retrieveStore()
                            
                            let storedData = forecastsDefaults.data(forKey: controllerConfig.objectKey)!
                            
                            storedStore = try! JSONDecoder().decode(ForecastStore.self, from: storedData)
                        }
                        
                        it("should return the default store") {
                            expect(actualStore.forecasts.keys) == expectedStore.forecasts.keys
                            expect(actualStore.forecasts.values.map { $0.id }) == actualStore.forecasts.values.map { $0.id }
                        }
                        
                        it("should remove the store that failed migration from userdefaults and replace it with the default store") {
                            expect(storedStore.forecasts.keys) == expectedStore.forecasts.keys
                            expect(storedStore.forecasts.values.map { $0.id }) == actualStore.forecasts.values.map { $0.id }
                        }
                    }
                    
                    context("when the error is a decoding error") {
                        var expectedStore: ForecastStore!
                        var actualStore: ForecastStore!
                        var storedStore: ForecastStore!
                        var controllerConfig: ControllerConfig!
                        
                        beforeEach {
                            controllerConfig = ControllerConfig.random(defaults: forecastsDefaults)
                            
                            let forecastController = ForecastController.random(
                                config: controllerConfig,
                                timeZonesController: timeZonesController,
                                migrator: AnyMigrator(EmptyForecastStoreMigrator())
                            )
                            
                            forecastsDefaults.set(Data(), forKey: controllerConfig.objectKey)
                            
                            expectedStore = ForecastStore.default
                            actualStore = forecastController.retrieveStore()
                            
                            let storedData = forecastsDefaults.data(forKey: controllerConfig.objectKey)!
                            
                            storedStore = try! JSONDecoder().decode(ForecastStore.self, from: storedData)
                        }
                        
                        it("should return the default store") {
                            expect(actualStore.forecasts.keys) == expectedStore.forecasts.keys
                            expect(actualStore.forecasts.values.map { $0.id }) == actualStore.forecasts.values.map { $0.id }
                        }
                        
                        it("should remove the store that failed migration from userdefaults and replace it with the default store") {
                            expect(storedStore.forecasts.keys) == expectedStore.forecasts.keys
                            expect(storedStore.forecasts.values.map { $0.id }) == actualStore.forecasts.values.map { $0.id }
                        }
                    }
                }
            }
            
            describe("its cachedForecast for date and location") {
                var actualForecast: TimedForecast!
                var forecastsSuiteName: String!
                var forecastsDefaults: UserDefaults!
                var timeZonesSuiteName: String!
                var timeZonesDefaults: UserDefaults!
                var timeZonesController: TimeZonesController!
                var forecastController: ForecastController!
                
                beforeEach {
                    forecastsSuiteName = String.wtw.random()
                    forecastsDefaults = UserDefaults(suiteName: forecastsSuiteName)!
                    timeZonesSuiteName = String.wtw.random()
                    timeZonesDefaults = UserDefaults(suiteName: timeZonesSuiteName)!
                    timeZonesController = TimeZonesController.random(defaults: timeZonesDefaults)
                    forecastController = ForecastController.random(
                        config: ControllerConfig.random(defaults: forecastsDefaults),
                        timeZonesController: timeZonesController
                    )
                }
                
                afterEach {
                    forecastsDefaults.removeSuite(named: forecastsSuiteName)
                    timeZonesDefaults.removeSuite(named: timeZonesSuiteName)
                }
                
                context("when a cached timezone cannot be found for the given location") {
                    beforeEach {
                        actualForecast = forecastController.cachedForecast(
                            for: Date.wtw.random(), location: ValidLocation.random()
                        )
                    }
                    
                    it("should return nil") {
                        expect(actualForecast).to(beNil())
                    }
                }
                
                context("when a cached timezone can be found for the given location") {
                    var location: ValidLocation!
                    
                    beforeEach {
                        location = ValidLocation.random()
                    }
                    
                    context("when a cached forecast cannot be found") {
                        beforeEach {
                            timeZonesController.cache(timeZone: TimeZone.current, for: location)
                            
                            actualForecast = forecastController.cachedForecast(
                                for: Date.wtw.random(), location: location
                            )
                        }
                        
                        it("should return nil") {
                            expect(actualForecast).to(beNil())
                        }
                    }
                    
                    context("when a cached forecast can be found") {
                        context("when the cached forecast is not valid") {
                            beforeEach {
                                let cacheInterval = ForecastType.present.cacheInterval * 1.1
                                
                                let forecast = TimedForecast(
                                    id: UUID(),
                                    forecast: try! Forecast.fixtures.valid.object(),
                                    timestamp: Date.now.addingTimeInterval(cacheInterval)
                                )
                                
                                let date = Date.now
                                
                                forecastController.cache(forecast: forecast, for: date, location: location)
                                
                                actualForecast = forecastController.cachedForecast(for: date, location: location)
                            }
                            
                            it("should return nil") {
                                expect(actualForecast).to(beNil())
                            }
                        }
                        
                        context("when the cached forecast is valid") {
                            var expectedForecast: TimedForecast!
                            
                            beforeEach {
                                expectedForecast = TimedForecast(
                                    id: UUID(),
                                    forecast: try! Forecast.fixtures.valid.object(),
                                    timestamp: .now
                                )
                                
                                let date = Date.now
                                
                                forecastController.cache(forecast: expectedForecast, for: date, location: location)
                                
                                actualForecast = forecastController.cachedForecast(for: date, location: location)
                            }
                            
                            it("should be returned") {
                                expect(actualForecast.id) == expectedForecast.id
                            }
                        }
                    }
                }
            }
            
            describe("its cache forecast for date and location") {
                var goodForecast: TimedForecast!
                var forecastsSuiteName: String!
                var forecastsDefaults: UserDefaults!
                var timeZonesSuiteName: String!
                var timeZonesDefaults: UserDefaults!
                var timeZonesController: TimeZonesController!
                var forecastController: ForecastController!
                var date: Date!
                var location: ValidLocation!
                var expectedTimeZone: TimeZone!
                var tooNewForecast: TimedForecast!
                var tooOldForecast: TimedForecast!
                var savedStore: ForecastStore!
                
                beforeEach {
                    forecastsSuiteName = String.wtw.random()
                    forecastsDefaults = UserDefaults(suiteName: forecastsSuiteName)!
                    timeZonesSuiteName = String.wtw.random()
                    timeZonesDefaults = UserDefaults(suiteName: timeZonesSuiteName)!
                    timeZonesController = TimeZonesController.random(defaults: timeZonesDefaults)
                    forecastController = ForecastController.random(
                        config: ControllerConfig.random(defaults: forecastsDefaults),
                        timeZonesController: timeZonesController
                    )
                    date = Date.wtw.random()
                    location = ValidLocation.random()
                    
                    let beforeWindow = ForecastWindow.Distance.inThePast.rawValue - 1
                    
                    tooOldForecast = TimedForecast(
                        id: UUID(),
                        forecast: try! Forecast.fixtures.valid.object(),
                        timestamp: .now
                    )
                    let tooOldDate = Date.now.addingTimeInterval(beforeWindow.days)
                    let tooOldRequest = ForecastRequest(
                        date: tooOldDate,
                        location: location,
                        timeZone: tooOldForecast.forecast.timeZone,
                        params: .init()
                    )
                    
                    let afterWindow = ForecastWindow.Distance.inTheFuture.rawValue + 1
                    
                    tooNewForecast = TimedForecast(
                        id: UUID(),
                        forecast: try! Forecast.fixtures.valid.object(),
                        timestamp: .now
                    )
                    
                    let tooNewDate = Date.now.addingTimeInterval(afterWindow.days)
                    let tooNewRequest = ForecastRequest(
                        date: tooNewDate,
                        location: location,
                        timeZone: tooNewForecast.forecast.timeZone,
                        params: .init()
                    )
                    
                    let store = ForecastStore(forecasts: [
                        tooOldRequest : tooOldForecast,
                        tooNewRequest : tooNewForecast
                    ])
                    
                    forecastController.save(store)
                    
                    goodForecast = TimedForecast(
                        id: UUID(), forecast: try! Forecast.fixtures.valid.object(), timestamp: .now
                    )
                    
                    expectedTimeZone = goodForecast.forecast.timeZone
                    
                    forecastController.cache(forecast: goodForecast, for: date, location: location)
                    
                    savedStore = forecastController.retrieve()
                }
                
                afterEach {
                    forecastsDefaults.removeSuite(named: forecastsSuiteName)
                    timeZonesDefaults.removeSuite(named: timeZonesSuiteName)
                }
                
                it("should cache the timezone from the given forecast") {
                    expect(timeZonesController.cachedTimeZone(for: location)) == expectedTimeZone
                }
                
                it("should filter out forecasts outside the forecast window") {
                    let storedIDs = savedStore.forecasts.values.map { $0.id }
                    
                    expect(storedIDs).toNot(contain(tooNewForecast.id))
                    expect(storedIDs).toNot(contain(tooOldForecast.id))
                }
                
                it("should cache the given forecast") {
                    expect(forecastController.cachedForecast(for: date, location: location)?.id) == goodForecast.id
                }
            }
            
            describe("its cache forecast when dates are across a day boundary") {
                var cachedForecastFor_dec24_2am: TimedForecast!
                var cachedForecastFor_dec24_4am: TimedForecast!
                var dec24_2am_timedforecast: TimedForecast!
                var dec24_4am_timedforecast: TimedForecast!
                var defaults: UserDefaults!
                var suiteName: String!

                beforeEach {
                    suiteName = String.wtw.random()
                    defaults = UserDefaults(suiteName: suiteName)!

                    let controller = ForecastController.random(config: ControllerConfig.random(defaults: defaults))
                    let location = ValidLocation.random()

                    var calendar = Calendar.current
                    calendar.timeZone = TimeZone(identifier: "America/Toronto")!

                    let dec24_2am = calendar.date(from: DateComponents(year: 2019, month: 12, day: 24, hour: 2))!
                    let dec24_4am = calendar.date(from: DateComponents(year: 2019, month: 12, day: 24, hour: 4))!

                    let timestamp = calendar.date(from: DateComponents(year: 2019, month: 12, day: 29, hour: 15))!

                    let dec24_2am_forecast = try! Forecast.fixtures.dec24_2am.object()
                    dec24_2am_timedforecast = TimedForecast(id: UUID(), forecast: dec24_2am_forecast, timestamp: timestamp)

                    let dec24_4am_forecast = try! Forecast.fixtures.dec24_4am.object()
                    dec24_4am_timedforecast = TimedForecast(id: UUID(), forecast: dec24_4am_forecast, timestamp: timestamp)
                    
                    // We filter around the timestamp, otherwise the cached forecasts get filtered out when we try to cache something
                    controller.cache(forecast: dec24_2am_timedforecast, for: dec24_2am, location: location, filterAround: timestamp)
                    controller.cache(forecast: dec24_4am_timedforecast, for: dec24_4am, location: location, filterAround: timestamp)

                    cachedForecastFor_dec24_2am = controller.cachedForecast(for: dec24_2am, location: location)
                    cachedForecastFor_dec24_4am = controller.cachedForecast(for: dec24_4am, location: location)
                }

                afterEach {
                    defaults.removeSuite(named: suiteName)
                }

                it("should return th correct cached forecasts") {
                    expect(cachedForecastFor_dec24_2am.id) == dec24_2am_timedforecast.id
                    expect(cachedForecastFor_dec24_4am.id) == dec24_4am_timedforecast.id
                }
            }
        }
    }
}
