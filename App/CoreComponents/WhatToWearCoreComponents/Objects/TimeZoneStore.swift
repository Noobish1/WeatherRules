import Foundation
import WhatToWearModels

// MARK: ForecastStore
public struct TimeZoneStore: Codable {
    // MARK: properties
    internal var timeZones: [ValidLocation: TimeZone]

    // MARK: init
    internal init(timeZones: [ValidLocation: TimeZone] = [:]) {
        self.timeZones = timeZones
    }
}

// MARK: DefaultsBackedObject
extension TimeZoneStore: DefaultsBackedObject {
    public typealias Version = TimeZoneStoreVersion
}

// MARK: DefaultsBackedObjectWithNonNilDefault
extension TimeZoneStore: DefaultsBackedObjectWithNonNilDefault {
    public static var `default`: Self {
        return TimeZoneStore()
    }
}
