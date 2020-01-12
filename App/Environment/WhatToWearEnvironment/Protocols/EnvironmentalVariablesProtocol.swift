import Foundation
import WhatToWearCore

public protocol EnvironmentalVariablesProtocol {
    static var DarkSkyBaseURLString: String { get }
    static var AppLookupBaseURLString: String { get }
    static var DarkSkyAPIKey: String { get }
    static var AppGroupPrefix: String { get }
    static var MainURLScheme: String { get }
    static var AppID: String { get }
    static var AppStoreURLString: String { get }
    static var AppCenterAPIKey: String { get }
}

extension EnvironmentalVariablesProtocol {
    public static var AppID: String {
        return "1418841967"
    }

    public static var AppStoreReviewsURLString: String {
        return "itms-apps://itunes.apple.com/app/\(AppID)?action=write-review"
    }

    public static var AppStoreReviewsURL: HardCodedURL {
        return HardCodedURL(AppStoreReviewsURLString)
    }

    public static var AppStoreURLString: String {
        return "itms-apps://itunes.apple.com/app/id\(AppID)"
    }

    public static var AppStoreURL: HardCodedURL {
        return HardCodedURL(AppStoreURLString)
    }

    public static var DarkSkyBaseURLString: String {
        return "https://api.darksky.net/"
    }

    public static var DarkSkyBaseURL: HardCodedURL {
        return HardCodedURL(DarkSkyBaseURLString)
    }

    public static var AppLookupBaseURLString: String {
        return "https://itunes.apple.com/"
    }

    public static var AppLookupBaseURL: HardCodedURL {
        return HardCodedURL(AppLookupBaseURLString)
    }
}
