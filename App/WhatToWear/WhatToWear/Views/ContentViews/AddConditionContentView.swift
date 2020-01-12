import SnapKit
import Then
import UIKit
import WhatToWearCoreUI

internal final class AddConditionContentView: CodeBackedView, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = AddConditionContentView

        case measurementButton = "measurementButton"
        case symbolButtonContainer = "symbolButtonContainer"
        case valueButtonContainer = "valueButtonContainer"
        case addButton = "addButton"
        case clearButton = "clearButton"
    }

    // MARK: properties
    private let navBarSeparatorView = SeparatorView()
    internal lazy var measurementButton = MeasurementButton(layout: layout).then {
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.measurementButton)
    }
    internal lazy var symbolButtonContainer = SymbolButtonContainerView(layout: layout).then {
        $0.accessibilityIdentifier = AccessibilityIdentifiers.symbolButtonContainer.rawValue
    }
    internal lazy var valueButtonContainer = ValueButtonContainerView(layout: layout).then {
        $0.accessibilityIdentifier = AccessibilityIdentifiers.valueButtonContainer.rawValue
    }
    private lazy var addButton = BottomAnchoredButton(
        bottomInset: self.wtw_bottomSafeInset,
        onTap: self.onAdd
    ).then {
        $0.accessibilityIdentifier = AccessibilityIdentifiers.addButton.rawValue
    }
    private let clearButtonTopSeparatorView = SeparatorView()
    internal let clearButton = CustomButton(color: Colors.failure).then {
        $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle(NSLocalizedString("Clear", comment: ""), for: .normal)
        $0.accessibilityIdentifier = AccessibilityIdentifiers.clearButton.rawValue
    }

    private let layout: AddConditionViewController.Layout
    private let onAdd: () -> Void

    // MARK: init
    internal init(
        state: AddConditionViewController.State,
        layout: AddConditionViewController.Layout,
        onAdd: @escaping () -> Void
    ) {
        self.layout = layout
        self.onAdd = onAdd

        super.init(frame: .zero)

        setupViews(state: state)
    }

    // MARK: setup
    private func setupViews(state: AddConditionViewController.State) {
        let outerXPadding = 2

        add(topSeparatorView: navBarSeparatorView)

        add(subview: measurementButton, withConstraints: { make in
            make.top.equalTo(navBarSeparatorView.snp.bottom).offset(10)
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide().offset(outerXPadding)
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide().inset(outerXPadding)
        })

        add(subview: symbolButtonContainer, withConstraints: { make in
            make.top.equalTo(measurementButton.snp.bottom).offset(10)
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide().offset(outerXPadding)
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide().inset(outerXPadding)
            make.height.equalTo(measurementButton)
        })

        add(subview: valueButtonContainer, withConstraints: { make in
            make.top.equalTo(symbolButtonContainer.snp.bottom).offset(10)
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide().offset(outerXPadding)
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide().inset(outerXPadding)
            make.height.equalTo(0).priority(.low)
        })

        add(topSeparatorView: clearButtonTopSeparatorView, beneath: valueButtonContainer)

        add(subview: clearButtonTopSeparatorView, withConstraints: { make in
            make.top.greaterThanOrEqualTo(valueButtonContainer.snp.bottom)
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
            make.height.equalTo(1)
        })

        add(subview: clearButton, withConstraints: { make in
            make.top.equalTo(clearButtonTopSeparatorView.snp.bottom)
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
            make.height.equalTo(Constants.bottomButtonHeight).priority(.high)
            make.height.greaterThanOrEqualTo(44)
        })

        add(subview: addButton, withConstraints: { make in
            make.top.equalTo(clearButton.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(44)
        })
        addButton.update(title: state.addButtonTitle)
    }

    // MARK: update
    internal func update(bottomInset: CGFloat) {
        addButton.update(bottomInset: bottomInset)
    }
}
