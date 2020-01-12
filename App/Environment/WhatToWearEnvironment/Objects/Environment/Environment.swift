import Foundation

public enum Environment {
    public static var isDev: Bool {
        #if DEV
            return true
        #else
            return false
        #endif
    }

    public static var isProduction: Bool {
        #if PRODUCTION
            return true
        #else
            return false
        #endif
    }

    public static var isCrashlyticsEnabled: Bool {
        #if CRASHLYTICS_ENABLED
            return true
        #else
            return false
        #endif
    }

    public static var Variables: EnvironmentalVariablesProtocol.Type {
        #if DEV
            return DevEnvironmentalVariables.self
        #elseif PRODUCTION
            return ProductionEnvironmentalVariables.self
        #else
            fatalError("The preprocessor macros DEV or PRODUCTION are not defined for your configuration")
        #endif
    }
}
