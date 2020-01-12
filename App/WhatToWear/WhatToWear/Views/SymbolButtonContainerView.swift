import Then
import UIKit
import WhatToWearCoreUI

internal final class SymbolButtonContainerView: CodeBackedView, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = SymbolButtonContainerView

        case symbolButton = "symbolButton"
        case selectedAndDisabledView = "selectedAndDisabledView"
    }

    internal enum State: Equatable {
        case notVisible
        case noSelection(SymbolButton)
        case highlightedNoSelection(SymbolButton)
        case selected(SymbolButton)
        case selectedAndDisabled(title: String)

        // MARK: computed properties
        internal func view(with layout: AddConditionViewController.Layout) -> UIView? {
            switch self {
                case .notVisible:
                    return nil
                case .noSelection(let symbolButton),
                     .highlightedNoSelection(let symbolButton),
                     .selected(let symbolButton):
                    return symbolButton.then {
                        $0.wtw_setAccessibilityIdentifier(
                            AccessibilityIdentifiers.symbolButton
                        )
                    }
                case .selectedAndDisabled(title: let title):
                    return SymbolButtonContentView(
                        title: title,
                        tickColor: .white,
                        valueLabelColor: .yellow,
                        bgColor: Colors.completed,
                        layout: layout
                    ).then {
                        $0.wtw_setAccessibilityIdentifier(
                            AccessibilityIdentifiers.selectedAndDisabledView
                        )
                    }
            }
        }

        fileprivate var borderColor: UIColor {
            switch self {
                case .notVisible: return .clear
                case .noSelection, .selected,
                     .selectedAndDisabled, .highlightedNoSelection:
                    return .white
            }
        }
    }

    // MARK: properties
    private let layout: AddConditionViewController.Layout
    private var state: State

    // MARK: init/deinit
    internal init(state: State = .notVisible, layout: AddConditionViewController.Layout) {
        self.layout = layout
        self.state = state

        super.init(frame: .zero)

        layer.borderWidth = 1

        transition(to: state, force: true)
    }

    // MARK: transition
    internal func transition(to newState: State, force: Bool = false) {
        guard force || state != newState else { return }

        subviews.forEach { $0.removeFromSuperview() }

        if let view = newState.view(with: layout) {
            add(fullscreenSubview: view)
        }

        layer.borderColor = newState.borderColor.cgColor

        self.state = newState
    }
}
