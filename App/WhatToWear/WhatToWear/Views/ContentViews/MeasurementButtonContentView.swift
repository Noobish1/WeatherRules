import UIKit
import WhatToWearCoreUI

internal final class MeasurementButtonContentView: CodeBackedView, AddConditionButtonContentViewProtocol {
    // MARK: Properties
    internal let centeredView = UIView().then {
        $0.isUserInteractionEnabled = false
    }
    internal let numberLabel = UILabel().then {
        $0.textColor = .white
        $0.text = NSLocalizedString("1", comment: "")
        $0.font = .boldSystemFont(ofSize: 40)
    }
    internal let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.text = NSLocalizedString("When", comment: "")
        $0.textAlignment = .center
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    internal lazy var valueLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = layout.valueFont
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    internal lazy var tickLabel = UILabel().then {
        $0.text = NSLocalizedString("✓", comment: "")
        $0.font = .systemFont(ofSize: 40)
    }
    internal let layout: AddConditionViewController.Layout
    
    // MARK: init
    internal init(layout: AddConditionViewController.Layout, buttonState: MeasurementButton.ButtonState) {
        self.layout = layout
        
        super.init(frame: .zero)
        
        isUserInteractionEnabled = false
        
        setupViews()
        transition(to: buttonState)
    }
    
    // MARK: transition
    internal func transition(to newButtonState: MeasurementButton.ButtonState) {
        valueLabel.text = newButtonState.value
        valueLabel.textColor = newButtonState.valueLabelColor
        tickLabel.textColor = newButtonState.tickColor
        backgroundColor = newButtonState.backgroundColor
    }
}
