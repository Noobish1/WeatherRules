import Then
import UIKit
import WhatToWearAssets
import WhatToWearCore
import WhatToWearCoreUI

// MARK: InputButton
internal class InputButton: CodeBackedControl, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = InputButton

        case titleLabel = "titleLabel"
        case editIconImageView = "editIconImageView"
    }

    // MARK: State
    internal enum ButtonState {
        case noSelection
        case selection(String)
        case highlightedNoSelection

        // MARK: init
        internal init(value: String?) {
            let trimmedValue = value?.trimmingCharacters(in: .whitespacesAndNewlines)

            switch trimmedValue {
                case .none:
                    self = .noSelection
                case .some(let value) where value.isEmpty:
                   self = .noSelection
                case .some(let value):
                    self = .selection(value)
            }
        }

        // MARK: computed properties
        fileprivate var valueLabelColor: UIColor {
            switch self {
                case .noSelection: return Colors.blueButton
                case .selection: return .yellow
                case .highlightedNoSelection: return .white
            }
        }

        internal var backgroundColor: UIColor {
            switch self {
                case .noSelection: return .clear
                case .selection: return Colors.completed
                case .highlightedNoSelection: return Colors.failure
            }
        }

        fileprivate var selectedBackgroundColor: UIColor {
            switch self {
                case .noSelection:
                    return Colors.selectedBackground
                case .selection:
                    return Colors.completed.darker(by: 20.percent)
                case .highlightedNoSelection:
                    return Colors.failure.darker(by: 20.percent)
            }
        }

        fileprivate var value: String? {
            switch self {
                case .noSelection: return nil
                case .selection(let value): return value
                case .highlightedNoSelection: return nil
            }
        }
    }

    // MARK: overrides
    internal override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? buttonState.selectedBackgroundColor : buttonState.backgroundColor
        }
    }

    // MARK: properties
    internal var ourAccessoryView: UIView {
        fatalError("Do not use InputButton directly")
    }
    internal lazy var titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = layout.valueFont
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.titleLabel)
    }

    private let editIconImageView = UIImageView(image: R.image.editIcon()).then {
        $0.tintColor = .white
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.editIconImageView)
    }
    private let defaultValue: String
    private let layout: AddConditionViewController.Layout
    internal private(set) var buttonState: ButtonState

    // MARK: UIResponder
    internal override var inputAccessoryView: UIView? {
        return ourAccessoryView
    }
    internal override var canBecomeFirstResponder: Bool {
        return true
    }

    // MARK: init/deinit
    internal init(
        state: ButtonState, layout: AddConditionViewController.Layout, defaultValue: String
    ) {
        self.defaultValue = defaultValue
        self.buttonState = state
        self.layout = layout

        super.init(frame: .zero)

        self.accessibilityTraits = .button
        self.addTarget(self, action: #selector(onTap), for: .touchUpInside)

        setupViews()
        transition(to: state)
    }

    // MARK: setup
    private func setupViews() {
        add(subview: titleLabel, withConstraints: { make in
            make.top.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(10)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview().priority(.high)
        })

        add(subview: editIconImageView, withConstraints: { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(2)
            make.trailing.lessThanOrEqualToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        })
    }

    // MARK: interface actions
    @objc
    internal func onTap() {
        self.becomeFirstResponder()
        _ = self.ourAccessoryView.becomeFirstResponder()
    }

    // MARK: transition
    internal func transition(to newState: ButtonState) {
        titleLabel.text = newState.value ?? defaultValue
        backgroundColor = newState.backgroundColor
        titleLabel.textColor = newState.valueLabelColor

        self.buttonState = newState
    }
}

// MARK: UIKeyInput
extension InputButton: UIKeyInput {
    internal var hasText: Bool {
        return false
    }

    internal func insertText(_ text: String) {}

    internal func deleteBackward() {}
}
