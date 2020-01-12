import UIKit
import WhatToWearCommonModels
import WhatToWearCore
import WhatToWearModels

// MARK: General extensions
extension UIColor {
    // MARK: Hex colors
    public convenience init(hex: Int, alpha: Double = 1.0) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255.0,
            green: CGFloat((hex >> 8) & 0xFF) / 255.0,
            blue: CGFloat(hex & 0xFF) / 255.0,
            alpha: CGFloat(255 * alpha) / 255
        )
    }

    // MARK: random
    public static func random() -> UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1
        )
    }

    // MARK: Adjusting methods
    // adapted from https://stackoverflow.com/a/38435309
    public func lighter(by percentage: Percentage<CGFloat>) -> UIColor {
        return self.adjust(by: abs(percentage.rawValue))
    }

    public func darker(by percentage: Percentage<CGFloat>) -> UIColor {
        return self.adjust(by: -1 * abs(percentage.rawValue))
    }

    public func adjust(by percentage: CGFloat) -> UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            fatalError("Could got get colors from image: \(self)")
        }

        return UIColor(red: min(red + percentage, 1.0),
                       green: min(green + percentage, 1.0),
                       blue: min(blue + percentage, 1.0),
                       alpha: alpha)
    }
}
