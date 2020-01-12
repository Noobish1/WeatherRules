import UIKit
import WhatToWearCoreUI
import WhatToWearModels

internal final class RulesContentView: CodeBackedView, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = RulesContentView

        case containerView = "containerView"
        case addGroupButton = "addGroupButton"
        case addRuleButton = "addRuleButton"
    }

    // MARK: properties
    private let navBarSeparatorView = SeparatorView()
    private let containerView: RulesContainerView
    private let bottomSeparatorView = SeparatorView()
    internal let addGroupButton = CustomButton(
        color: Colors.orangeButton
    ).then {
        $0.setTitle(NSLocalizedString("Add Rule Group", comment: ""), for: .normal)
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.addGroupButton)
    }
    private lazy var addRuleButton = BottomAnchoredButton(
        bottomInset: self.wtw_bottomSafeInset,
        onTap: self.onAddRule
    ).then {
        $0.update(title: NSLocalizedString("Add Rule", comment: ""))
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.addRuleButton)
    }

    private let onAddRule: () -> Void

    // MARK: init
    internal init(
        rules: StoredRules,
        system: MeasurementSystem,
        configureEmptyView: @escaping (RuleEmptyView) -> Void,
        configureFullView: @escaping (RulesFullView) -> Void,
        onAddRule: @escaping () -> Void
    ) {
        self.containerView = RulesContainerView(
            rules: rules,
            system: system,
            configureEmptyView: configureEmptyView,
            configureFullView: configureFullView
        ).then {
            $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.containerView)
        }
        self.onAddRule = onAddRule

        super.init(frame: .zero)

        setupViews()
    }

    // MARK: setup
    private func setupViews() {
        add(topSeparatorView: navBarSeparatorView)

        add(subview: containerView, withConstraints: { make in
            make.top.equalTo(navBarSeparatorView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        })

        add(topSeparatorView: bottomSeparatorView, beneath: containerView)

        add(subview: addGroupButton, withConstraints: { make in
            make.top.equalTo(bottomSeparatorView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(50)
        })

        add(subview: addRuleButton, withConstraints: { make in
            make.top.equalTo(addGroupButton.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        })
    }

    // MARK: update
    internal func update(bottomInset: CGFloat) {
        addRuleButton.update(bottomInset: bottomInset)
    }

    // MARK: update
    internal func update(with rules: StoredRules, system: MeasurementSystem) {
        containerView.update(with: rules, system: system)
    }
}
