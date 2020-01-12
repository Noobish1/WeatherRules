import SnapKit
import Then
import UIKit
import WhatToWearCoreUI

internal final class AddRuleContentView: CodeBackedView, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = AddRuleContentView

        case tableView = "tableView"
        case nameButton = "nameButton"
        case addConditionButton = "addConditionButton"
        case addConditionContainerView = "addConditionContainerView"
        case addButton = "addButton"
        case containerView = "containerView"
    }

    // MARK: properties
    private let navBarSeparatorView = SeparatorView()
    private let containerView: RuleAdditionContainerView<AddRuleFullView>
    internal lazy var nameButton = TextInputButton(
        title: NSLocalizedString("Name", comment: ""),
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
    internal let addConditionButton = BorderedButton().then {
        $0.setTitle(NSLocalizedString("Add Condition", comment: ""), for: .normal)
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.addConditionButton)
    }
    private let addConditionContainerView = UIView().then {
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.addConditionContainerView)
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
        conditions: [ConditionViewModel],
        configureEmptyView: @escaping (RuleEmptyView) -> Void,
        configureFullView: @escaping (AddRuleFullView) -> Void,
        onNameChange: @escaping (String) -> Void,
        onAdd: @escaping () -> Void
    ) {
        self.initialName = name
        self.onNameChange = onNameChange
        self.containerView = RuleAdditionContainerView<AddRuleFullView>(
            viewModels: conditions,
            configureEmptyView: configureEmptyView,
            configureFullView: configureFullView,
            emptyConfig: .addRule
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

        add(subview: addConditionContainerView, withConstraints: { make in
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
            make.bottom.equalTo(addButton.snp.top)
        })

        addConditionContainerView.add(subview: addConditionButton, withConstraints: { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(44)
        })

        add(separatorView: nameButtonBottomSeparatorView, above: addConditionContainerView)

        add(subview: nameButton, withConstraints: { make in
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
            make.height.equalTo(44)
            make.bottom.equalTo(nameButtonBottomSeparatorView.snp.top)
        })

        add(separatorView: topSeparatorView, above: nameButton)

        add(subview: containerView, withConstraints: { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(topSeparatorView.snp.top)
        })
    }

    // MARK: configuration
    internal func configure(with state: AddRuleViewController.State) {
        nameButton.transition(to: .init(value: state.name))
        addButton.update(title: state.initialAddButtonTitle)
        containerView.update(with: state.conditions)
    }

    // MARK: update
    internal func update(bottomInset: CGFloat) {
        addButton.update(bottomInset: bottomInset)
    }
}
