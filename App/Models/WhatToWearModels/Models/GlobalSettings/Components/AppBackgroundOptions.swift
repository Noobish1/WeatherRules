import Foundation
import WhatToWearCommonCore
import WhatToWearCore

// MARK: AppBackgroundOptions
public enum AppBackgroundOptions: String, NonEmptyCaseIterable, Codable, Equatable {
    case original = "original"
    case blueToRed = "blueToRed"
    case blueToBrown = "blueToBrown"
    case blackToPink = "darkOrange"
    case darkBlue = "darkBlue"
    case darkGreen = "darkGreen"
    case darkPurple = "darkPurple"
    case darkPink = "darkPink"
    case darkRed = "darkRed"

    public var background: AppBackground {
        switch self {
            case .original:
                return .gradient(
                    hexColors: [0x06101c, 0x142f4a, 0x144c7b, 0x326c33, 0x2a5f2f],
                    locations: [0, 0.56, 0.76, 0.98, 1]
                )
            case .blueToRed:
                return .gradient(hexColors: [0x2C4367, 0xBA421B], locations: [0, 1])
            case .blueToBrown:
                return .gradient(hexColors: [0x082575, 0x584652], locations: [0, 1])
            case .blackToPink:
                return .gradient(hexColors: [0x100215, 0x833274], locations: [0, 1])
            case .darkBlue:
                return .color(hex: 0x0A1525)
            case .darkGreen:
                return .color(hex: 0x082A10)
            case .darkPurple:
                return .color(hex: 0x1C0925)
            case .darkPink:
                return .color(hex: 0x2B0920)
            case .darkRed:
                return .color(hex: 0x380F0B)
        }
    }
}

// MARK: WTWRandomized
extension AppBackgroundOptions: WTWRandomized {
    // swiftlint:disable type_name
    public enum wtw: WTWRandomizer {
        public static func random() -> AppBackgroundOptions {
            return nonEmptyCases.randomElement()
        }
    }
    // swiftlint:enable type_name
}
