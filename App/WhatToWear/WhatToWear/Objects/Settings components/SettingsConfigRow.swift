import Foundation

internal enum SettingsConfigRow: Int, SettingsRowProtocol, SettingsDetailCellProtocol {
    case units = 0
    case temperatureType = 1
    case windType = 2
    case whatsNewOnLaunch = 3
    case chartComponents = 4
    case appBackground = 5

    // MARK: computed properties
    internal var title: String {
        switch self {
            case .units:
                return NSLocalizedString("Measurement System", comment: "")
            case .temperatureType:
                return NSLocalizedString("Temperature Type", comment: "")
            case .windType:
                return NSLocalizedString("Wind Type", comment: "")
            case .whatsNewOnLaunch:
                return NSLocalizedString("What's New On Launch", comment: "")
            case .chartComponents:
                return NSLocalizedString("Visible Chart Components", comment: "")
            case .appBackground:
                return NSLocalizedString("App Background", comment: "")
        }
    }

    internal var shouldHighlight: Bool {
        switch self {
            case .units, .temperatureType, .windType, .whatsNewOnLaunch:
                return false
            case .chartComponents, .appBackground:
                return true
        }
    }
}
