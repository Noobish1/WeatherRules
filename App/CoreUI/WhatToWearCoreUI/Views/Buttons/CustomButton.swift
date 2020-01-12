import UIKit

open class CustomButton: CodeBackedButton {
    // MARK: overrides
    open override var isHighlighted: Bool {
        didSet {
            if bgColor == .clear {
                backgroundColor = isHighlighted ? Colors.selectedBackground : bgColor
            } else {
                backgroundColor = isHighlighted ? bgColor.darker(by: 20.percent) : bgColor
            }
        }
    }

    // MARK: properties
    public var bgColor: UIColor {
        didSet {
            backgroundColor = bgColor
        }
    }

    // MARK: init
    public init(color: UIColor) {
        self.bgColor = color

        super.init(frame: .zero)

        backgroundColor = color
    }
}
