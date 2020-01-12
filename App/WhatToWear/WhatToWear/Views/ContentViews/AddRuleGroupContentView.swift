import SnapKit
import Then
import UIKit
import WhatToWearCore
import WhatToWearCoreUI
import WhatToWearModels

internal final class AddRuleGroupContentView: CodeBackedView, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = AddRuleGroupContentView

        case containerView = "containerView"
        case nameButton = "nameButton"
        case newRuleButton = "newRuleButton"
        case existingRuleButton = "existingRuleButton"
        case buttonContainerView = "buttonContainerView"
        case addButton = "addButton"
    }

    // MARK: properties
    private let navBarSeparatorView = SeparatorView()
    private let containerView: RuleAdditionContainerView<AddRuleGroupFullView>
    internal let defaultName = NSLocalizedString("Name", comment: "")
    internal lazy var nameButton = TextInputButton(
        title: self.defaultName,
        value: self.initialName,
        layout: .large, // We hardcode this because we haven't had problems with this
        onDone: { [onNameChange] _, state in
            switch state {
                case .noSelection, .highlightedNoSelection:
                    onNameChange("")
                case .selection(let value):
                    onNameChange(value)
            }
        }
    ).then {
        $0.titleLabel.font = .boldSystemFont(ofSize: 24)
        $0.titleLabel.numberOfLines = 2
        $0.backgroundColor = .clear
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.nameButton)
    }
    private let nameButtonBottomSeparatorView = SeparatorView()
    internal let newRuleButton = BorderedButton().then {
        $0.setTitle(NSLocalizedString("New Rule", comment: ""), for: .normal)
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.newRuleButton)
    }
    internal let existingRuleButton = BorderedButton().then {
        $0.setTitle(NSLocalizedString("Existing Rule", comment: ""), for: .normal)
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.existingRuleButton)
    }
    private let buttonContainerView = UIView().then {
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.buttonContainerView)
    }
    private lazy var addButton = BottomAnchoredButton(
        bottomInset: self.wtw_bottomSafeInset,
        onTap: self.onAdd
    ).then {
        $0.update(title: NSLocalizedString("Add", comment: ""))
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.addButton)
    }
    private let topSeparatorView = SeparatorView().then {
        ShadowConfigurator.configureTopShadow(for: $0)
    }
    private let initialName: String?
    private let onNameChange: (String) -> Void
    private let onAdd: () -> Void

    // MARK: init
    internal init(
        name: String?,
        rules: [RuleViewModel],
        configureEmptyView: @escaping (RuleEmptyView) -> Void,
        configureFullView: @escaping (AddRuleGroupFullView) -> Void,
        onNameChange: @escaping (String) -> Void,
        onAdd: @escaping () -> Void
    ) {
        self.initialName = name
        self.onNameChange = onNameChange
        self.containerView = RuleAdditionContainerView<AddRuleGroupFullView>(
            viewModels: rules,
            configureEmptyView: configureEmptyView,
            configureFullView: configureFullView,
            emptyConfig: .addRuleGroup
        ).then {
            $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.containerView)
        }
        self.onAdd = onAdd

        super.init(frame: .zero)

        setupViews()
    }

    // MARK: setup
    private func setupViews() {
        add(topSeparatorView: navBarSeparatorView)

        add(subview: addButton, withConstraints: { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        })

        add(subview: buttonContainerView, withConstraints: { make in
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
            make.bottom.equalTo(addButton.snp.top)
        })

        buttonContainerView.add(subview: newRuleButton, withConstraints: { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(44)
        })

        buttonContainerView.add(subview: existingRuleButton, withConstraints: { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(newRuleButton.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(44)
            make.width.equalTo(newRuleButton)
        })

        add(separatorView: nameButtonBottomSeparatorView, above: buttonContainerView)

        add(subview: nameButton, withConstraints: { make in
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
            make.height.equalTo(44)
            make.bottom.equalTo(nameButtonBottomSeparatorView.snp.top)
        })

        add(separatorView: topSeparatorView, above: nameButton)

        add(subview: containerView, withConstraints: { make in
            make.top.equalTo(navBarSeparatorView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(topSeparatorView.snp.top)
        })
    }

    // MARK: configuration
    internal func configure(with state: AddRuleGroupViewController.State) {
        nameButton.transition(to: .init(value: state.name))
        addButton.update(title: state.initialAddButtonTitle)
        containerView.update(with: state.rules)
    }

    // MARK: update
    internal func update(bottomInset: CGFloat) {
        addButton.update(bottomInset: bottomInset)
    }
}
