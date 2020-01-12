import Foundation
import NotificationCenter

public enum AnalyticsEvent {
    case forecastRequest
    case lookupRequest
    case ruleAdded(name: String, numberOfConditions: Int)
    case ruleGroupAdded(name: String, numberOfRules: Int)
    case conditionAdded(String, measurement: String)
    case reviewPromptPotentiallyShown
    case locationSelected
    case currentLocationTapped
    case currentLocationSelected
    case measurementSystemChanged(String)
    case temperatureTypeChanged(String)
    case lastSeenUpdateChanged(String)
    case windTypeChanged(String)
    case whatsNewOnLaunchChanged(Bool)
    case settingsLinkTapped(String)
    case timeSettingsTimeRangeChanged(String)
    case timeSettingsIntervalChanged(String)
    case mainAppOpenedFromExtension(AnalyticsScreen.TodayExtension)
    case rulesDeepLinkOpened(AnalyticsScreen.TodayExtension)
    case legendDeepLinkOpened(AnalyticsScreen.TodayExtension)
    case widgetDisplayModeChanged(NCWidgetDisplayMode)
    case ruleGroupHelpButtonTapped
    case priorityInfoButtonTapped
    case ruleHelpButtonTapped
    case viewFullVersionHistory

    internal var event: CustomEvent {
        switch self {
            case .forecastRequest:
                return CustomEvent(name: "Forecast Request")
            case .lookupRequest:
                return CustomEvent(name: "Lookup Request")
            case .ruleAdded(name: let name, numberOfConditions: let numberOfConditions):
                return CustomEvent(
                    name: "Rule Added",
                    customAttributes: [
                        "name": name,
                        "numberOfConditions": String(numberOfConditions)
                    ]
                )
            case .ruleGroupAdded(name: let name, numberOfRules: let numberOfRules):
                return CustomEvent(
                    name: "Rule Group Added",
                    customAttributes: [
                        "name": name,
                        "numberOfConditions": String(numberOfRules)
                    ]
                )
            case .conditionAdded(let condition, measurement: let measurement):
                return CustomEvent(
                    name: "Condition Added",
                    customAttributes: [
                        "metricStringRepresentation": condition,
                        "measurement": measurement
                    ]
                )
            case .reviewPromptPotentiallyShown:
                return CustomEvent(name: "Review Prompt Potentially Shown")
            case .locationSelected:
                return CustomEvent(name: "Location Selected")
            case .currentLocationTapped:
                return CustomEvent(name: "Current Locatio Tapped")
            case .currentLocationSelected:
                return CustomEvent(name: "Current Location Selected")
            case .measurementSystemChanged(let system):
                return CustomEvent(
                    name: "Measurement System Changed",
                    customAttributes: [
                        "system": system
                    ]
                )
            case .temperatureTypeChanged(let temperatureType):
                return CustomEvent(
                    name: "Temperature Type Changed",
                    customAttributes: [
                        "type": temperatureType
                    ]
                )
            case .lastSeenUpdateChanged(let lastSeenUpdate):
                return CustomEvent(
                    name: "Last Seen Update Changed",
                    customAttributes: [
                        "lastSeenUpdate" : lastSeenUpdate
                    ]
                )
            case .windTypeChanged(let windType):
                return CustomEvent(
                    name: "Wind Type Changed",
                    customAttributes: [
                        "type": windType
                    ]
                )
            case .whatsNewOnLaunchChanged(let value):
                return CustomEvent(
                    name: "What's New On Launch Changed",
                    customAttributes: [
                        "value": String(value)
                    ]
                )
            case .settingsLinkTapped(let link):
                return CustomEvent(
                    name: "Settings Link Tapped",
                    customAttributes: [
                        "link": link
                    ]
                )
            case .timeSettingsTimeRangeChanged(let timeRange):
                return CustomEvent(
                    name: "Time Settings Time Range Changed",
                    customAttributes: [
                        "timerange": timeRange
                    ]
                )
            case .timeSettingsIntervalChanged(let interval):
                return CustomEvent(
                    name: "Time Settings Interval Changed",
                    customAttributes: [
                        "interval": interval
                    ]
                )
            case .mainAppOpenedFromExtension(let todayExtension):
                return CustomEvent(
                    name: "Main App Opened From Extension",
                    customAttributes: [
                        "extension": todayExtension.rawValue
                    ]
                )
            case .rulesDeepLinkOpened(let todayExtension):
                return CustomEvent(
                    name: "Rules Deep Link Opened",
                    customAttributes: [
                        "extension": todayExtension.rawValue
                    ]
                )
            case .legendDeepLinkOpened(let todayExtension):
                return CustomEvent(
                    name: "Legend Deep Link Opened",
                    customAttributes: [
                        "extension": todayExtension.rawValue
                    ]
                )
            case .widgetDisplayModeChanged(let displayMode):
                return CustomEvent(
                    name: "Widget Display Mode Changed",
                    customAttributes: [
                        "displaymode": displayMode.analyticsValue
                    ]
                )
            case .ruleGroupHelpButtonTapped:
                return CustomEvent(name: "Rule Group Help Button Tapped")
            case .priorityInfoButtonTapped:
                return CustomEvent(name: "Priority Info Button Tapped")
            case .ruleHelpButtonTapped:
                return CustomEvent(name: "Rule Help Button Tapped")
            case .viewFullVersionHistory:
                return CustomEvent(name: "View Full Version History")
        }
    }
}
