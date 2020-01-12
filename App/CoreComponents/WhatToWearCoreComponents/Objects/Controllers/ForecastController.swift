import ErrorRecorder
import Foundation
import Tagged
import WhatToWearCore
import WhatToWearModels

public final class ForecastController: DefaultsBackedControllerWithNonOptionalObject {
    // MARK: typealiases
    public typealias Object = ForecastStore

    // MARK: properties
    public let config: ControllerConfig
    public let migrator: AnyMigrator<ForecastStore>
    private let timeZonesController: TimeZonesController

    // MARK: init
    public convenience init() {
        self.init(config: .forecasts, timeZonesController: TimeZonesController(), migrator: AnyMigrator(ForecastStoreMigrator()))
    }

    internal init(config: ControllerConfig, timeZonesController: TimeZonesController, migrator: AnyMigrator<ForecastStore>) {
        self.config = config
        self.migrator = migrator
        self.timeZonesController = timeZonesController
    }

    // MARK: retrieving forecasts
    public func cachedForecast(for date: Date, location: ValidLocation) -> TimedForecast? {
        guard let timeZone = timeZonesController.cachedTimeZone(for: location) else {
            return nil
        }
        
        let store = retrieveStore()
        
        let request = ForecastRequest(
            date: date, location: location, timeZone: timeZone, params: ForecastParameters()
        )
        
        guard
            let storedForecast = store.forecasts[request],
            isForecastValid(storedForecast, for: date, timeZone: timeZone)
        else {
            return nil
        }
        
        return storedForecast
    }
    
    // MARK: validation
    private func isForecastValid(
        _ storedForecast: TimedForecast, for date: Date, timeZone: TimeZone
    ) -> Bool {
        let type = ForecastType(date: date, timeZone: timeZone)

        return abs(storedForecast.timestamp.date.timeIntervalSinceNow) < type.cacheInterval
    }
    
    // MARK: retrieving
    internal func retrieveStore() -> ForecastStore {
        switch retrieveWithResult() {
            case .success(let store):
                return store
            case .failure(let retrievalError):
                let errorToLog: WTWError
                
                switch retrievalError {
                    case .migration(fromVersion: _, error: let migrationError):
                        // Migrating failed but that isn't a big deal because its just cached forecasts
                        errorToLog = WTWError(
                            format: "Migrating ForecastStore failed with error: %@",
                            arguments: [migrationError.localizedDescription]
                        )
                    case .decoding(let error):
                        // This should only happen when we change one of the models we store,
                        // it isn't that big of a deal as it's just a cache anyway
                        errorToLog = WTWError(
                            format: "Decoding during ForecastStore retrieval failed with error: %@",
                            arguments: [error.localizedDescription]
                        )
                }
            
                ErrorRecorder.record(errorToLog)
                
                removeObject()
                
                // This will save the default, empty ForecastStore and return it
                return retrieve()
        }
    }
    
    // MARK: caching forecasts
    public func cache(
        forecast timedForecast: TimedForecast,
        for date: Date,
        location: ValidLocation,
        filterAround filterDate: Date = .now
    ) {
        let timeZone = timedForecast.forecast.timeZone
        
        // Cache the timeZone
        timeZonesController.cache(timeZone: timeZone, for: location)
        
        // Cache forecast
        let request = ForecastRequest(
            date: date,
            location: location,
            timeZone: timeZone,
            params: ForecastParameters()
        )
        
        var store = retrieveStore()
        store.filterForecastsOutside(window: .around(date: filterDate, timeZone: timeZone))
        store.forecasts[request] = timedForecast

        save(store)
    }
}
