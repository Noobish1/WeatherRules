import AppCenterAnalytics
import Foundation

public enum Analytics {
    // MARK: content views
    public static func record(screen: AnalyticsScreen) {
        record(screen.event)
    }

    private static func record(_ event: ContentViewEvent) {
        MSAnalytics.trackEvent("Screen View - \(event.name)")
    }

    // MARK: custom event
    public static func record(event: AnalyticsEvent) {
        record(event.event)
    }

    private static func record(_ event: CustomEvent) {
        MSAnalytics.trackEvent(
            event.name,
            withProperties: event.customAttributes
        )
    }
}
