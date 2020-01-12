import Foundation
import WhatToWearCore

internal enum SettingsSocialRow: Int, SettingsRowProtocol, SettingsAttributedCellProtocol {
    case appTwitter = 0
    case devTwitter = 1
    case email = 2

    // MARK: computed properties
    internal var attributedText: NSAttributedString {
        switch self {
            case .appTwitter:
                let format = NSLocalizedString("Follow development %@", comment: "")
                let linkBit = NSLocalizedString("@WeatherRulesApp", comment: "")

                return linkString(
                    from: String(format: format, arguments: [linkBit]),
                    linkPart: linkBit
                )
            case .devTwitter:
                let format = NSLocalizedString("Follow the developer %@", comment: "")
                let linkBit = NSLocalizedString("@Noobish1", comment: "")

                return linkString(
                    from: String(format: format, arguments: [linkBit]),
                    linkPart: linkBit
                )
            case .email:
                let format = NSLocalizedString("%@ the developer", comment: "")
                let linkBit = NSLocalizedString("Email", comment: "")

                return linkString(
                    from: String(format: format, arguments: [linkBit]),
                    linkPart: linkBit
                )
        }
    }

    internal var shouldHighlight: Bool {
        switch self {
            case .appTwitter, .devTwitter, .email: return true
        }
    }
}
