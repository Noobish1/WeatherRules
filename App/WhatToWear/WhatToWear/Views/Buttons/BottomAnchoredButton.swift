import SnapKit
import Then
import UIKit
import WhatToWearCoreUI

internal final class BottomAnchoredButton: CodeBackedControl {
    // MARK: properties
    private let topSeparatorView = SeparatorView()
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.backgroundColor = .clear
        $0.font = .boldSystemFont(ofSize: 20)
        $0.textAlignment = .center
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.setContentHuggingPriority(.required, for: .vertical)
    }
    // swiftlint:disable implicitly_unwrapped_optional
    private var idealBottomConstraint: Constraint!
    private var minimumBottomConstraint: Constraint!
    private var idealTopConstraint: Constraint!
    private var minimumTopConstraint: Constraint!
    private var centerConstraint: Constraint!
    // swiftlint:enable implicitly_unwrapped_optional

    internal override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? bgColor.darker(by: 20.percent) : bgColor
        }
    }

    private let bgColor: UIColor
    private let onTap: () -> Void

    // MARK: init
    internal init(
        bottomInset: CGFloat,
        bgColor: UIColor = Colors.blueButton,
        onTap: @escaping () -> Void
    ) {
        self.bgColor = bgColor
        self.onTap = onTap

        super.init(frame: .zero)

        self.accessibilityTraits = .button
        self.backgroundColor = bgColor
        self.addTarget(self, action: #selector(selfTapped), for: .touchUpInside)

        setupViews(bottomInset: bottomInset)
    }

    // MARK: setup
    private func setupViews(bottomInset: CGFloat) {
        let actualIdealBottomInset = idealBottomInset(initialValue: bottomInset)
        let actualMinimumBottomInset = minimumBottomInset(initialValue: bottomInset)
        let actualIdealTopOffset = idealTopOffset(bottomInset: bottomInset)
        let actualMinimumTopOffset = minimumTopOffset(bottomInset: bottomInset)

        add(topSeparatorView: topSeparatorView)

        add(subview: titleLabel, withConstraints: { make in
            minimumTopConstraint = make.top.greaterThanOrEqualTo(topSeparatorView.snp.bottom).offset(actualMinimumTopOffset).constraint
            idealTopConstraint = make.top.equalTo(topSeparatorView.snp.bottom).offset(actualIdealTopOffset).priority(.high).constraint
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            centerConstraint = make.centerY.equalToSuperview().constraint
            idealBottomConstraint = make.bottom.equalToSuperview().inset(actualIdealBottomInset).priority(.high).constraint
            minimumBottomConstraint = make.bottom.lessThanOrEqualToSuperview().inset(actualMinimumBottomInset).constraint
        })

        if shouldDisableCenterConstraint(forBottomInset: bottomInset) {
            centerConstraint.deactivate()
        } else {
            centerConstraint.activate()
        }
    }

    // MARK: interface actions
    @objc
    private func selfTapped() {
        onTap()
    }

    // MARK: update
    internal func update(bottomInset: CGFloat) {
        let actualIdealBottomInset = idealBottomInset(initialValue: bottomInset)
        let actualMinimumBottomInset = minimumBottomInset(initialValue: bottomInset)
        let actualIdealTopOffset = idealTopOffset(bottomInset: bottomInset)
        let actualMinimumTopOffset = minimumTopOffset(bottomInset: bottomInset)

        idealBottomConstraint.update(inset: actualIdealBottomInset)
        minimumBottomConstraint.update(inset: actualMinimumBottomInset)
        idealTopConstraint.update(offset: actualIdealTopOffset)
        minimumTopConstraint.update(offset: actualMinimumTopOffset)

        if shouldDisableCenterConstraint(forBottomInset: bottomInset) {
            centerConstraint.deactivate()
        } else {
            centerConstraint.activate()
        }
    }

    internal func update(title: String) {
        titleLabel.text = title
    }

    private func shouldDisableCenterConstraint(forBottomInset bottomInset: CGFloat) -> Bool {
        return bottomInset > 0
    }

    private func idealTopOffset(bottomInset: CGFloat) -> CGFloat {
        return bottomInset > 0 ? 20 : 18
    }

    private func minimumTopOffset(bottomInset: CGFloat) -> CGFloat {
        return bottomInset > 0 ? 16 : 10
    }

    private func idealBottomInset(initialValue: CGFloat) -> CGFloat {
        return initialValue > 0 ? initialValue : 18
    }

    private func minimumBottomInset(initialValue: CGFloat) -> CGFloat {
        return initialValue > 0 ? 24 : 10
    }
}
