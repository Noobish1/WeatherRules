import UIKit

internal final class UnderlinedButton: UIButton {
    // MARK: computed properties
    private var titleAttributes: [NSAttributedString.Key: Any] = [
        .underlineStyle: NSUnderlineStyle.single.rawValue,
        .underlineColor: UIColor.white,
        .font: UIFont.systemFont(ofSize: 18, weight: .semibold),
        .foregroundColor: UIColor.white
    ]

    private var highlightedAttributes: [NSAttributedString.Key: Any] {
        var attributes = titleAttributes
        attributes[.foregroundColor] = UIColor.white.darker(by: 30.percent)

        return attributes
    }

    // MARK: init
    internal convenience init(title: String) {
        self.init(type: .system)

        let string = NSAttributedString(string: title, attributes: titleAttributes)
        let highlightedString = NSAttributedString(string: title, attributes: highlightedAttributes)

        setAttributedTitle(string, for: .normal)
        setAttributedTitle(highlightedString, for: .highlighted)
    }
}
