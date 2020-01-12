import Foundation
import WhatToWearCommonCore
import WhatToWearCore
import WhatToWearModels

public struct WhatsNewUpdateViewModel {
    // MARK: properties
    public let version: OperatingSystemVersion
    public let segments: NonEmptyArray<WhatsNewSegmentViewModel>
    
    // MARK: init
    public init(version: OperatingSystemVersion, segments: NonEmptyArray<WhatsNewSegmentViewModel>) {
        self.version = version
        self.segments = segments
    }
    
    public init(version: WhatsNewVersion) {
        self.version = version.rawValue
        self.segments = Self.segments(for: version)
    }
    
    // MARK: static init helpers
    // swiftlint:disable cyclomatic_complexity
    private static func segments(for version: WhatsNewVersion) -> NonEmptyArray<WhatsNewSegmentViewModel> {
        // swiftlint:disable line_length
        switch version {
            case .one_one_zero:
                return NonEmptyArray(elements:
                    WhatsNewSegmentViewModel(
                        title: NSLocalizedString("Legend", comment: ""),
                        subtitle: NSLocalizedString("There is now a chart legend which can be accessed from a forecast. The forecast describes each chart component, what they look like and what they mean.", comment: "")
                    ),
                    WhatsNewSegmentViewModel(
                        title: NSLocalizedString("‘Go Back To Today’ Buttons", comment: ""),
                        subtitle: NSLocalizedString("When reaching the last supported date either in the future or the past, there is now a helpful button to take you back to today", comment: "")
                    ),
                    WhatsNewSegmentViewModel(
                        title: NSLocalizedString("Time Settings Help", comment: ""),
                        subtitle: NSLocalizedString("There are now help buttons on the time settings screen (shown when tapping the middle of the bottom toolbar)", comment: "")
                    )
                )
            case .one_two_zero:
                return NonEmptyArray(elements:
                    WhatsNewSegmentViewModel(
                        title: NSLocalizedString("Humidity", comment: ""),
                        subtitle: NSLocalizedString("Humidity is now shown on forecasts, it is shown as a green line. It is shown as a percentage, zero is at the bottom of the graph and 100 is at the top.", comment: "")
                    ),
                    WhatsNewSegmentViewModel(
                        title: NSLocalizedString("Visible Chart Components", comment: ""),
                        subtitle: NSLocalizedString("There is a new setting which allows you to select which components you want to see on the chart.", comment: "")
                    )
                )
            case .one_three_zero:
                return NonEmptyArray(elements:
                    WhatsNewSegmentViewModel(
                        title: NSLocalizedString("Sun Altitude", comment: ""),
                        subtitle: NSLocalizedString("Sun Altitude has been added to forecasts, it is a yellow line which shows  the altitude of the sun in the sky as a percentage of its max altitude. Sun Altitude is also a measurement which can be used in rules.", comment: "")
                    ),
                    WhatsNewSegmentViewModel(
                        title: NSLocalizedString("Wind", comment: ""),
                        subtitle: NSLocalizedString("Wind Gust and Wind Direction have been split into two seperate chart components and can be enabled/disable separately.", comment: "")
                    ),
                    WhatsNewSegmentViewModel(
                        title: NSLocalizedString("Data refreshing", comment: ""),
                        subtitle: NSLocalizedString("The App now refreshes when left in the background for long periods of time.", comment: "")
                    )
                )
            case .one_four_zero:
                return NonEmptyArray(elements:
                    WhatsNewSegmentViewModel(
                        title: NSLocalizedString("Daily Measurements and descriptions", comment: ""),
                        subtitle: NSLocalizedString("Conditions can now be made using measurements that are for the entire day rather than hourly (e.g. the time at which the wind gust speed is the highest). Because of this Measurements are now split into two sections, “Hourly” and “Daily”. Measurements also now have descriptions in the Measurements screen.", comment: "")
                    ),
                    WhatsNewSegmentViewModel(
                        title: NSLocalizedString("New Time Measurement Symbols", comment: ""),
                        subtitle: NSLocalizedString("Time based conditions can now use “Before” and “After” as their symbol.", comment: "")
                    ),
                    WhatsNewSegmentViewModel(
                        title: NSLocalizedString("Location Search Indicator", comment: ""),
                        subtitle: NSLocalizedString("When searching for a location there is now an activity indicator while the search is in progress.", comment: "")
                    ),
                    WhatsNewSegmentViewModel(
                        title: NSLocalizedString("Conditions removed from rules screen", comment: ""),
                        subtitle: NSLocalizedString("Conditions are no longer shown on the rules screen so more rules can be shown on one screen.", comment: "")
                    )
                )
            case .one_five_zero:
                return NonEmptyArray(elements:
                    WhatsNewSegmentViewModel(
                        title: NSLocalizedString("Added the 'What's New' screen", comment: ""),
                        subtitle: NSLocalizedString("Added this What's new screen that you’re currently viewing! It should be especially helpful if you have automatic updates turned on.", comment: "")
                    ),
                    WhatsNewSegmentViewModel(
                        title: NSLocalizedString("App Backgrounds", comment: ""),
                        subtitle: NSLocalizedString("You can now change the background of the app via the setting screen.", comment: "")
                    ),
                    WhatsNewSegmentViewModel(
                        title: NSLocalizedString("'Day of Week' Measurement", comment: ""),
                        subtitle: NSLocalizedString("You can use this for rules that are only valid for certain days of the week.", comment: "")
                    ),
                    WhatsNewSegmentViewModel(
                        title: NSLocalizedString("App Updates Available", comment: ""),
                        subtitle: NSLocalizedString("The app will now unobtrusively let you know when an update is available in the App Store by badging the settings icon on the toolbar, it can be dismissed by navigating into the settings screen and tapping the dismiss button.", comment: "")
                    ),
                    WhatsNewSegmentViewModel(
                        title: NSLocalizedString("Email the Developer", comment: ""),
                        subtitle: NSLocalizedString("You can now Email the developer via a link in the settings screen.", comment: "")
                    )
                )
            case .one_six_zero:
                return NonEmptyArray(elements:
                    WhatsNewSegmentViewModel(
                        title: NSLocalizedString("Disable What's New On Launch", comment: ""),
                        subtitle: NSLocalizedString("You can now disable the 'What's New' screen that appears on launch. This can be done in the settings screen.", comment: "")
                    ),
                    WhatsNewSegmentViewModel(
                        title: NSLocalizedString("Show Wind Speed or Wind Gust on Forecasts", comment: ""),
                        subtitle: NSLocalizedString("You can now decide whether to show Wind Speed or Wind Gust on forecasts. This can be done in the settings screen.", comment: "")
                    ),
                    WhatsNewSegmentViewModel(
                        title: NSLocalizedString("Show Apparent Temperature or Air Temperature on Forecasts", comment: ""),
                        subtitle: NSLocalizedString("You can now decide whether to show Apparent Temperature or Air Temperature on Forecasts. This can be done in the settings screen.", comment: "")
                    )
                )
            case .one_seven_zero:
                return NonEmptyArray(elements:
                    WhatsNewSegmentViewModel(
                        title: NSLocalizedString("Combined Today Extension", comment: ""),
                        subtitle: NSLocalizedString("A New Combined Today Extension has been added which shows the forecast or met rules for today as well as past and future dates.", comment: "")
                    )
                )
            case .one_eight_zero:
                return NonEmptyArray(elements:
                    WhatsNewSegmentViewModel(
                        title: NSLocalizedString("Combined Today Extension Availability", comment: ""),
                        subtitle: NSLocalizedString("The Combined Today Extension is now available on iOS 10 and iOS 11.", comment: "")
                    )
                )
            case .one_nine_zero:
                return NonEmptyArray(elements:
                    WhatsNewSegmentViewModel(
                        title: NSLocalizedString("Multiple locations", comment: ""),
                        subtitle: NSLocalizedString("You can now have save multiple locations, to add a location navigate to the Locations screen by tapping the pin icon on the left of the bottom toolbar.", comment: "")
                    ),
                    WhatsNewSegmentViewModel(
                        title: NSLocalizedString("Quickly switching locations", comment: ""),
                        subtitle: NSLocalizedString("You can quickly switch between your locations by holding down on the pin icon then selecting a location.", comment: "")
                    )
                )
            case .two_zero_zero:
                return NonEmptyArray(elements:
                    WhatsNewSegmentViewModel(
                        title: NSLocalizedString("iPad Support", comment: ""),
                        subtitle: NSLocalizedString("A Brand new iPad version, with all the same features from the iPhone version!", comment: "")
                    )
                )
            case .two_one_zero:
                return NonEmptyArray(elements:
                    WhatsNewSegmentViewModel(
                        title: NSLocalizedString("New Year, New Forecasts", comment: ""),
                        subtitle: NSLocalizedString("Happy New Year!\n\nTo bring in the new year, forecast charts have been split into two in order to display even more weather information.\n\nThe top chart shows Cloud Cover, Solar Noon, Sun Altitude, Wind Direction, Wind Speed and Humidity.\n\nThe Bottom chart shows Chance Of Precipitation, Precipitation Type, Precipitation Amount and Temperature.\n\nThe Current Time is displayed on both charts.\n\nNote: Any of the above mentioned Chart Components can be disabled in Settings -> Visible Chart Components.", comment: "")
                    )
                )
        }
        // swiftlint:enable line_length
    }
    // swiftlint:enable cyclomatic_complexity
}
