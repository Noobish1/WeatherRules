import UIKit
import WhatToWearCoreUI

internal final class ValueButtonContainerView: CodeBackedView, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = ValueButtonContainerView

        case numberLabel = "numberLabel"
        case tickLabel = "tickLabel"
        case doubleButton = "doubleButton"
        case basicButton = "basicButton"
        case timeRangeView = "timeRangeView"
    }

    internal enum State: Equatable {
        case notVisible
        case doubleButton(DoubleInputButton)
        case basicButton(BasicValueButton)
        case timeRangeView(TimeRangeView)

        // MARK: computed properties
        fileprivate var tickColor: UIColor {
            switch self {
                case .notVisible:
                    return .clear
                case .doubleButton(let button):
                    switch button.buttonState {
                        case .noSelection, .highlightedNoSelection: return .clear
                        case .selection: return .white
                    }
                case .basicButton(let button):
                    switch button.state {
                        case .noSelection, .highlightedNoSelection: return .clear
                        case .selection: return .white
                    }
                case .timeRangeView:
                    // We always have a timeRange
                    return .white
            }
        }

        fileprivate var backgroundColor: UIColor {
            switch self {
                case .notVisible:
                    return .clear
                case .doubleButton(let button):
                    return button.buttonState.backgroundColor
                case .basicButton(let button):
                    return button.state.backgroundColor
                case .timeRangeView:
                    // We always have a timeRange
                    return Colors.completed
            }
        }

        fileprivate var view: UIView? {
            switch self {
                case .notVisible: return nil
                case .doubleButton(let doubleButton): return doubleButton
                case .basicButton(let basicButton): return basicButton
                case .timeRangeView(let view): return view
            }
        }
    }

    // MARK: properties
    private let numberLabel = UILabel().then {
        $0.textColor = .white
        $0.text = NSLocalizedString("3", comment: "")
        $0.font = .boldSystemFont(ofSize: 40)
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.numberLabel)
    }
    private lazy var tickLabel = UILabel().then {
        $0.textColor = state.tickColor
        $0.text = NSLocalizedString("✓", comment: "")
        $0.font = .systemFont(ofSize: 40)
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.tickLabel)
    }
    private let layout: AddConditionViewController.Layout
    internal private(set) var state: State = .notVisible

    // MARK: init/deinit
    internal init(layout: AddConditionViewController.Layout) {
        self.layout = layout

        super.init(frame: .zero)

        backgroundColor = state.backgroundColor
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor

        transition(to: state, force: true)
    }

    // MARK: layout
    private func layoutBasic(view: UIView) {
        add(subview: view, withConstraints: { make in
            make.edges.equalToSuperview()
            make.height.equalTo(80).priority(.high)
            make.height.greaterThanOrEqualTo(50)
        })

        layoutNumberAndTickLabels()
    }

    private func layout(timeRangeView: TimeRangeView) {
        timeRangeView.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.timeRangeView)

        add(subview: timeRangeView, withConstraints: { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().inset(40)
            make.bottom.equalToSuperview()
            make.height.equalTo(80).priority(.high)
            make.height.greaterThanOrEqualTo(50)
        })

        layoutNumberAndTickLabels()
    }

    private func layoutNumberAndTickLabels() {
        add(subview: numberLabel, withConstraints: { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(layout.outerXPadding)
        })
        add(subview: tickLabel, withConstraints: { make in
            make.trailing.equalToSuperview().inset(layout.outerXPadding)
            make.centerY.equalToSuperview()
        })
    }

    private func layout(for state: State) {
        switch state {
            case .timeRangeView(let view):
                layout(timeRangeView: view)
            case .notVisible:
                break
            case .basicButton(let view):
                view.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.basicButton)
                layoutBasic(view: view)
            case .doubleButton(let view):
                view.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.doubleButton)
                layoutBasic(view: view)
        }
    }

    // MARK: transition
    internal func transition(to newState: State, force: Bool = false) {
        guard force || state != newState else { return }

        subviews.forEach { $0.removeFromSuperview() }

        layout(for: newState)

        tickLabel.textColor = newState.tickColor
        backgroundColor = newState.backgroundColor

        self.state = newState
    }
}
