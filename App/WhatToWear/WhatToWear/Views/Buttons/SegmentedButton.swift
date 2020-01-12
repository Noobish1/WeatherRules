import UIKit
import WhatToWearCoreUI

internal final class SegmentedButton: CodeBackedButton {
    // MARK: properties
    private let bgColor: UIColor
    
    // MARK: overrides
    internal override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = bgColor
            } else {
                backgroundColor = .clear
            }
        }
    }

    internal override var isHighlighted: Bool {
        didSet {
            if isSelected {
                if isHighlighted {
                    backgroundColor = bgColor.darker(by: 20.percent)
                } else {
                    backgroundColor = bgColor
                }
            } else {
                if isHighlighted {
                    backgroundColor = Colors.selectedBackground
                } else {
                    backgroundColor = .clear
                }
            }
        }
    }

    // MARK: init
    internal init(bgColor: UIColor) {
        self.bgColor = bgColor
        
        super.init(frame: .zero)

        backgroundColor = .clear

        self.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        setTitleColor(bgColor, for: .normal)
        setTitleColor(.white, for: .selected)
    }
}
