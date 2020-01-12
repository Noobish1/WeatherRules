import UIKit
import WhatToWearCoreUI

// MARK: SettingsRowProtocol
internal protocol SettingsRowProtocol: RawRepresentable, CaseIterable where RawValue == Int {
    var shouldHighlight: Bool { get }

    static func make(rawValue: Int) -> Self
}

// MARK: Extensions
extension SettingsRowProtocol {
    // MARK: making
    internal static func make(rawValue: Int) -> Self {
        guard let section = Self(rawValue: rawValue) else {
            fatalError("\(rawValue) is not a valid \(self)")
        }

        return section
    }

    // MARK: making attributed text
    internal func linkString(from string: String, linkPart: String) -> NSAttributedString {
        let mainAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 15, weight: .semibold)
        ]

        let string = NSMutableAttributedString(string: string, attributes: mainAttributes)

        let linkRange = (string.string as NSString).range(of: linkPart)
        let linkAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Colors.blueButton
        ]

        string.addAttributes(linkAttributes, range: linkRange)

        return string
    }
}
