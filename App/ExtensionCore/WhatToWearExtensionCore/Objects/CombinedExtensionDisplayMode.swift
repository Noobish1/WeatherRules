import Foundation

public enum CombinedExtensionDisplayMode: String, Codable, Equatable {
    case forecast = "forecast"
    case rules = "rules"
    
    // MARK: computed properties
    public var stringRepresentation: String {
        switch self {
            case .forecast: return NSLocalizedString("Forecast", comment: "")
            case .rules: return NSLocalizedString("Met Rules", comment: "")
        }
    }
    
    // MARK: toggling
    public func toggled() -> Self {
        switch self {
            case .forecast: return .rules
            case .rules: return .forecast
        }
    }
}
