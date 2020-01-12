import UIKit
import WhatToWearCoreUI

internal class SymbolButtonContentView: CodeBackedView, AddConditionButtonContentViewProtocol {
    // MARK: properties
    internal let centeredView = UIView().then {
        $0.isUserInteractionEnabled = false
    }
    internal let numberLabel = UILabel().then {
        $0.textColor = .white
        $0.text = NSLocalizedString("2", comment: "")
        $0.font = .boldSystemFont(ofSize: 40)
    }
    internal let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.text = NSLocalizedString("Is", comment: "")
        $0.textAlignment = .center
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    internal lazy var valueLabel = UILabel().then {
        $0.textColor = valueLabelColor
        $0.textAlignment = .center
        $0.font = layout.valueFont
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    internal lazy var tickLabel = UILabel().then {
        $0.textColor = tickColor
        $0.text = NSLocalizedString("✓", comment: "")
        $0.font = .systemFont(ofSize: 40)
    }
    private let tickColor: UIColor
    private let valueLabelColor: UIColor
    private let bgColor: UIColor
    internal let layout: AddConditionViewController.Layout

    // MARK: init/deinit
    internal init(
        title: String,
        tickColor: UIColor,
        valueLabelColor: UIColor,
        bgColor: UIColor,
        layout: AddConditionViewController.Layout
    ) {
        self.tickColor = tickColor
        self.valueLabelColor = valueLabelColor
        self.bgColor = bgColor
        self.layout = layout

        super.init(frame: .zero)

        backgroundColor = bgColor
        isUserInteractionEnabled = false
        valueLabel.text = title

        setupViews()
    }
}
