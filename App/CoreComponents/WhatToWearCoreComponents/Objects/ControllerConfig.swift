import Foundation

// MARK: ControllerConfig
public struct ControllerConfig {
    // MARK: properties
    internal let objectKey: String
    internal let objectVersionKey: String
    internal let defaults: UserDefaults
    
    // MARK: init
    public init(objectKey: String, objectVersionKey: String, defaults: UserDefaults) {
        self.objectKey = objectKey
        self.objectVersionKey = objectVersionKey
        self.defaults = defaults
    }
}

// MARK: configs
extension ControllerConfig {
    internal static var rules: Self {
        return Self(
            objectKey: "rules",
            objectVersionKey: "rulesVersion",
            defaults: .rules
        )
    }

    internal static var globalSettings: Self {
        return Self(
            objectKey: "globalSettings",
            objectVersionKey: "globalSettingsVersion",
            defaults: .globalSettings
        )
    }

    internal static var forecasts: Self {
        return Self(
            objectKey: "forecastStore",
            objectVersionKey: "forecastStoreVersion",
            defaults: .forecasts
        )
    }

    internal static var timeSettings: Self {
        return Self(
            objectKey: "timeSettings",
            objectVersionKey: "timeSettingsVersion",
            defaults: .timeSettings
        )
    }
    
    internal static var locations: Self {
        return Self(
            objectKey: "location",
            objectVersionKey: "locationVersion",
            defaults: .location
        )
    }
    
    internal static var timeZones: Self {
        return Self(
            objectKey: "timeZones",
            objectVersionKey: "timeZonesVersion",
            defaults: .timeZones
        )
    }
}
