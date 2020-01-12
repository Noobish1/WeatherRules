import Foundation
import WhatToWearCore
import WhatToWearEnvironment

// MARK: public extensions
extension UserDefaults {
    public static func resetAllSuites() {
        UserDefaults.Suite.allCases.forEach { suite in
            UserDefaults.standard.removePersistentDomain(forName: suite.name)
        }
    }
}

// MARK: internal extensions
extension UserDefaults {
    // MARK: Suite
    internal enum Suite: CaseIterable {
        case forecasts
        case timeSettings
        case location
        case rules
        case globalSettings
        case timeZones

        // MARK: computed properties
        private var suffix: String {
            switch self {
                case .forecasts: return "forecasts"
                case .timeSettings: return "timesettings"
                case .location: return "location"
                case .rules: return "rules"
                case .globalSettings: return "globalsettings"
                case .timeZones: return "timezones"
            }
        }

        internal var name: String {
            return "\(Environment.Variables.AppGroupPrefix)\(suffix)"
        }
    }

    // MARK: defaults
    internal static var globalSettings: UserDefaults {
        return UserDefaults.make(suite: .globalSettings)
    }

    internal static var forecasts: UserDefaults {
        return UserDefaults.make(suite: .forecasts)
    }

    internal static var timeSettings: UserDefaults {
        return UserDefaults.make(suite: .timeSettings)
    }

    internal static var location: UserDefaults {
        return UserDefaults.make(suite: .location)
    }

    internal static var rules: UserDefaults {
        return UserDefaults.make(suite: .rules)
    }
    
    internal static var timeZones: UserDefaults {
        return UserDefaults.make(suite: .timeZones)
    }

    // MARK: creation
    internal static func make(suite: Suite) -> UserDefaults {
        guard let defaults = self.init(suiteName: suite.name) else {
            fatalError("Could not create UserDefaults with suite name: \(suite.name)")
        }

        return defaults
    }
}
