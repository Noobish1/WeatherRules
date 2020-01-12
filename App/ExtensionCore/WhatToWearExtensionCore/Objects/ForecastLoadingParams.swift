import Foundation
import NotificationCenter
import WhatToWearCore
import WhatToWearModels

@dynamicMemberLookup
public struct ForecastLoadingParams: Withable {
    // MARK: properties
    public var loadingContainerParams: LoadingContainerParams
    public let timedForecast: TimedForecast
    public let settings: GlobalSettings
    
    // MARK: with functions
    public func with<V>(_ keyPath: WritableKeyPath<LocationContainerParams, V>, value: V) -> Self {
        return self.with(\.loadingContainerParams, value: loadingContainerParams.with(keyPath, value: value))
    }
    
    public func with<V>(_ keyPath: WritableKeyPath<LoadingContainerParams, V>, value: V) -> Self {
        return self.with(\.loadingContainerParams, value: loadingContainerParams.with(keyPath, value: value))
    }
    
    // MARK: subscript
    public subscript<T>(dynamicMember keyPath: KeyPath<LoadingContainerParams, T>) -> T {
        return loadingContainerParams[keyPath: keyPath]
    }
}
