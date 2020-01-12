import Foundation
import WhatToWearModels

internal final class TimeZonesController: DefaultsBackedControllerWithNonOptionalObject {
    // MARK: typealiases
    internal typealias Object = TimeZoneStore

    // MARK: properties
    internal let config: ControllerConfig
    internal let migrator: AnyMigrator<TimeZoneStore>

    // MARK: init
    internal convenience init() {
        self.init(config: .timeZones, migrator: AnyMigrator(TimeZoneStoreMigrator()))
    }

    internal init(config: ControllerConfig, migrator: AnyMigrator<TimeZoneStore>) {
        self.config = config
        self.migrator = migrator
    }
    
    // MARK: caching
    internal func cache(timeZone: TimeZone, for location: ValidLocation) {
        var store = retrieve()
        store.timeZones[location] = timeZone

        save(store)
    }
    
    internal func cachedTimeZone(for location: ValidLocation) -> TimeZone? {
        let store = retrieve()
        
        return store.timeZones[location]
    }
}
