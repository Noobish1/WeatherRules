import UIKit

public enum AnalyticsScreen {
    public enum TodayExtension: String {
        case forecast = "ForecastExtension"
        case rules = "RulesExtension"
        case combined = "CombinedExtension"
    }

    public enum Target {
        case mainApp
        case todayExtension(TodayExtension)

        internal var stringValue: String {
            switch self {
                case .mainApp: return "Main App"
                case .todayExtension(let todayExtension):
                    return todayExtension.rawValue
            }
        }
    }

    case noRules(TodayExtension)
    case metRules(Target)
    case rulesLoading(TodayExtension)
    case today(TodayExtension)
    case forecastLoading(TodayExtension)
    case noLocation(TodayExtension)
    case day
    case addCondition
    case select(forType: Any.Type, from: UIViewController.Type)
    case addRule
    case rules
    case timeInput(from: UIViewController.Type)
    case addRuleGroup
    case addExistingRules
    case preloading
    case emptyMetRules
    case locationSelection
    case welcome
    case currentLocation
    case end(side: String, target: Target)
    case timeSettings
    case settings
    case loading(forLoadedViewController: UIViewController.Type)
    case error(forLoadedViewController: UIViewController.Type)
    case addExistingRulesEmptyView
    case legend
    case legendComponent(String)
    case selectMeasurement
    case whatsNew

    internal var event: ContentViewEvent {
        switch self {
            case .noRules:
                return ContentViewEvent(name: "No Rules")
            case .metRules(let target):
                return ContentViewEvent(name: "Met Rules (\(target.stringValue))")
            case .rulesLoading(let todayExtension):
                return ContentViewEvent(name: "Rules Loading (\(todayExtension.rawValue))")
            case .today:
                return ContentViewEvent(name: "Today")
            case .forecastLoading(let todayExtension):
                return ContentViewEvent(name: "Forecast Loading (\(todayExtension.rawValue))")
            case .noLocation(let todayExtension):
                return ContentViewEvent(name: "No Location (\(todayExtension.rawValue))")
            case .day:
                return ContentViewEvent(name: "Day")
            case .addCondition:
                return ContentViewEvent(name: "Add Condition")
            case .select(forType: let type):
                return ContentViewEvent(name: "Select (\(type))")
            case .addRule:
                return ContentViewEvent(name: "Add Rule")
            case .rules:
                return ContentViewEvent(name: "Rules")
            case .timeInput(from: let type):
                return ContentViewEvent(name: "TimeInput from \(type)")
            case .addRuleGroup:
                return ContentViewEvent(name: "Add Rule Group")
            case .addExistingRules:
                return ContentViewEvent(name: "Add Existing Rules")
            case .preloading:
                return ContentViewEvent(name: "Preloading")
            case .emptyMetRules:
                return ContentViewEvent(name: "Empty Met Rules")
            case .locationSelection:
                return ContentViewEvent(name: "Location Selection")
            case .welcome:
                return ContentViewEvent(name: "Welcome")
            case .currentLocation:
                return ContentViewEvent(name: "Current Location")
            case .end(side: let side):
                return ContentViewEvent(name: "End (\(side))")
            case .timeSettings:
                return ContentViewEvent(name: "Time Settings")
            case .settings:
                return ContentViewEvent(name: "Settings")
            case .loading(forLoadedViewController: let fromType):
                return ContentViewEvent(name: "Loading for \(fromType)")
            case .error(forLoadedViewController: let fromType):
                return ContentViewEvent(name: "Error for \(fromType)")
            case .addExistingRulesEmptyView:
                return ContentViewEvent(name: "Add Existing Rules Empty View")
            case .legend:
                return ContentViewEvent(name: "Legend")
            case .legendComponent(let component):
                return ContentViewEvent(name: "Legend Component: \(component)")
            case .selectMeasurement:
                return ContentViewEvent(name: "Select Measurement")
            case .whatsNew:
                return ContentViewEvent(name: "What's New")
        }
    }
}
