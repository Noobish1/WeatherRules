import Then
import UIKit
import WhatToWearCoreUI

internal final class TextInputButton: InputButton {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = TextInputButton

        case ourAccessoryView = "ourAccessoryView"
    }

    // MARK: properties
    internal override var ourAccessoryView: UIView {
        return ourActualAccessoryView
    }

    private lazy var ourActualAccessoryView = TextAccessoryView(
        title: title,
        value: initialValue,
        onDone: { [unowned self] value in
            let newState = ButtonState(value: value)

            self.transition(to: newState)

            self.onDone(self, newState)

            self.resignFirstResponder()
        }
    ).then {
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.ourAccessoryView)
    }
    private let title: String
    private let onDone: (TextInputButton, ButtonState) -> Void
    private let initialValue: String?

    // MARK: init/deinit
    internal init(
        title: String,
        value: String?,
        layout: AddConditionViewController.Layout,
        onDone: @escaping (TextInputButton, ButtonState) -> Void
    ) {
        self.title = title
        self.initialValue = value
        self.onDone = onDone

        super.init(state: .init(value: value), layout: layout, defaultValue: title)
    }
}
