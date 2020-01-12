import ErrorRecorder
import Foundation
import WhatToWearCore
import WhatToWearEnvironment

public enum DeepLink: String {
    case mainApp = ""
    case rules = "rules"
    case legend = "legend"
    
    // MARK: computed properties
    private var host: String {
        return rawValue
    }
    
    public var url: HardCodedURL {
        let urlString = Environment.Variables.MainURLScheme + "://"
        
        switch self {
            case .mainApp:
                return HardCodedURL(urlString)
            case .rules, .legend:
                return HardCodedURL(urlString + self.host)
        }
    }
    
    // MARK: init
    public init?(url: URL) {
        guard url.scheme == Environment.Variables.MainURLScheme else {
            return nil
        }
        
        guard let host = url.host else {
            return nil
        }
        
        guard let link = DeepLink(rawValue: host.lowercased()) else {
            return nil
        }
        
        self = link
    }
    
    // MARK: analytics
    public func analyticsEvent(for todayExtension: AnalyticsScreen.TodayExtension) -> AnalyticsEvent {
        switch self {
            case .mainApp:
                return .mainAppOpenedFromExtension(todayExtension)
            case .rules:
                return .rulesDeepLinkOpened(todayExtension)
            case .legend:
                return .legendDeepLinkOpened(todayExtension)
        }
    }
}
