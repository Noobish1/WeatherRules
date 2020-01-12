import UIKit
import WhatToWearCommonCore
import WhatToWearCore
import WhatToWearCoreUI
import WhatToWearModels

internal final class AddExistingRulesContentView: CodeBackedView, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = AddExistingRulesContentView

        case containerView = "containerView"
    }

    // MARK: properties
    private let navBarSeparatorView = SeparatorView()
    private let containerView: AddExistingRulesContainerView

    // MARK: init
    internal init(
        rules: [Rule],
        system: MeasurementSystem,
        onRulesSelected: @escaping (NonEmptyArray<RuleViewModel>) -> Void,
        onNoRulesSelected: @escaping () -> Void,
        configureEmptyView: @escaping (AddExistingRulesEmptyView) -> Void,
        configureFullView: @escaping (AddExistingRulesFullView) -> Void
    ) {
        self.containerView = AddExistingRulesContainerView(
            rules: rules.map {
                RuleViewModel(rule: $0, system: system, isExisting: true)
            },
            onRulesSelected: onRulesSelected,
            onNoRulesSelected: onNoRulesSelected,
            configureEmptyView: configureEmptyView,
            configureFullView: configureFullView
        ).then {
            $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.containerView)
        }

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
            make.bottom.equalToSuperview()
        })
    }

    // MARK: update
    internal func update(bottomInset: CGFloat) {
        containerView.update(bottomInset: bottomInset)
    }
}
