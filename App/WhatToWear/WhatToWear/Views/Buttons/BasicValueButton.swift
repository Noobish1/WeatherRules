import UIKit
import WhatToWearCoreUI

internal final class BasicValueButton: CodeBackedView, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = BasicValueButton

        case button = "button"
    }

    // MARK: State
    internal enum State {
        case noSelection
        case selection(String)
        case highlightedNoSelection

        // MARK: init
        internal init(value: String?) {
            switch value {
                case .none: self = .noSelection
                case .some(let value): self = .selection(value)
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
                case .noSelection: return Colors.selectedBackground
                case .selection: return Colors.completed.darker(by: 20.percent)
                case .highlightedNoSelection: return Colors.failure.darker(by: 20.percent)
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

    // MARK: properties
    private lazy var button = CustomButton(color: state.backgroundColor).then {
        $0.setTitleColor(state.valueLabelColor, for: .normal)
        $0.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.button)
    }
    private let defaultValue = NSLocalizedString("Value", comment: "")
    private let onTap: (BasicValueButton) -> Void
    private let layout: AddConditionViewController.Layout
    internal private(set) var state: State

    // MARK: init/deinit
    internal init(
        title: String?,
        layout: AddConditionViewController.Layout,
        onTap: @escaping (BasicValueButton) -> Void
    ) {
        self.state = .init(value: title)
        self.layout = layout
        self.onTap = onTap

        super.init(frame: .zero)

        setupViews()
        transition(to: state)
    }

    // MARK: setup
    private func setupViews() {
        add(fullscreenSubview: button)
    }

    // MARK: interface actions
    @objc
    private func onButtonTap() {
        onTap(self)
    }

    // MARK: transition
    internal func transition(to newState: State) {
        button.setTitle(newState.value ?? defaultValue, for: .normal)
        button.setTitleColor(newState.valueLabelColor, for: .normal)
        button.bgColor = newState.backgroundColor

        self.state = newState
    }
}
