import NotificationCenter
import WhatToWearCore
import WhatToWearModels

// MARK: LoadingContainerParams
@dynamicMemberLookup
public struct LoadingContainerParams: Withable {
    // MARK: properties
    public var locationContainerParams: LocationContainerParams
    public let location: ValidLocation
    
    // MARK: init
    public init(
        locationContainerParams: LocationContainerParams,
        location: ValidLocation
    ) {
        self.locationContainerParams = locationContainerParams
        self.location = location
    }
    
    // MARK: with
    public func with<V>(_ keyPath: WritableKeyPath<LocationContainerParams, V>, value: V) -> Self {
        return self.with(\.locationContainerParams, value: locationContainerParams.with(keyPath, value: value))
    }
    
    // MARK: subscript
    public subscript<T>(dynamicMember keyPath: KeyPath<LocationContainerParams, T>) -> T {
        return locationContainerParams[keyPath: keyPath]
    }
}
