import Foundation

public enum ProductionEnvironmentalVariables: EnvironmentalVariablesProtocol {
    #warning("Replace the placeholder DarkSky API Key and the AppCenter API Key if you wish")
    
    public static let DarkSkyAPIKey = "NOT_A_REAL_DARK_SKY_API_KEY"
    public static let AppGroupPrefix = "group.noobish1.weatherapp."
    public static let MainURLScheme = "weatherrules"
    public static let AppCenterAPIKey = "NOT_A_REAL_APP_CENTER_API_KEY"
}
