import Foundation
import WhatToWearCore

internal enum SettingsOtherRow: Int, SettingsRowProtocol, SettingsAttributedCellProtocol {
    case leaveAReview = 0
    case whatsNew = 1
    case darkSkyAttribution = 2

    // MARK: computed properties
    internal var attributedText: NSAttributedString {
        switch self {
            case .leaveAReview:
                let format = NSLocalizedString("Leave a %@", comment: "")
                let linkBit = NSLocalizedString("Review", comment: "")

                return linkString(
                    from: String(format: format, arguments: [linkBit]),
                    linkPart: linkBit
                )
            case .whatsNew:
                let format = NSLocalizedString("See %@", comment: "")
                let linkBit = NSLocalizedString("What's New", comment: "")

                return linkString(
                    from: String(format: format, arguments: [linkBit]),
                    linkPart: linkBit
                )
            case .darkSkyAttribution:
                let format = NSLocalizedString("Powered by %@", comment: "")
                let linkBit = NSLocalizedString("Dark Sky", comment: "")

                return linkString(
                    from: String(format: format, arguments: [linkBit]),
                    linkPart: linkBit
                )
        }
    }

    internal var shouldHighlight: Bool {
        switch self {
            case .leaveAReview, .whatsNew, .darkSkyAttribution: return true
        }
    }
}
