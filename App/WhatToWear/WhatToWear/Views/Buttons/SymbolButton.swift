import UIKit
import WhatToWearCoreUI
import WhatToWearModels

internal final class SymbolButton: CodeBackedControl {
    // MARK: State
    internal enum ButtonState {
        case noSelection(measurement: WeatherMeasurement)
        case selected(pair: MeasurementSymbolPair)
        case highlightedNoSelection(measurement: WeatherMeasurement)

        // MARK: computed properties
        fileprivate var title: String {
            switch self {
                case .noSelection, .highlightedNoSelection:
                    return NSLocalizedString("Symbol", comment: "")
                case .selected(pair: let pair):
                    return MeasurementSymbolPairViewModel.titleForSymbol(for: pair)
            }
        }

        fileprivate var valueLabelColor: UIColor {
            switch self {
                case .noSelection: return Colors.blueButton
                case .selected: return .yellow
                case .highlightedNoSelection: return .white
            }
        }

        fileprivate var backgroundColor: UIColor {
            switch self {
                case .noSelection: return .clear
                case .selected: return Colors.completed
                case .highlightedNoSelection: return Colors.failure
            }
        }

        fileprivate var selectedBackgroundColor: UIColor {
            switch self {
                case .noSelection:
                    return Colors.selectedBackground
                case .selected:
                    return Colors.completed.darker(by: 20.percent)
                case .highlightedNoSelection:
                    return Colors.failure.darker(by: 20.percent)
            }
        }

        fileprivate var tickColor: UIColor {
            switch self {
                case .noSelection, .highlightedNoSelection: return .clear
                case .selected: return .white
            }
        }
    }

    // MARK: overrides
    internal override var isHighlighted: Bool {
        didSet {
            contentView.backgroundColor = isHighlighted ? buttonState.selectedBackgroundColor : buttonState.backgroundColor
        }
    }

    // MARK: properties
    private let onTap: (SymbolButton) -> Void
    private let contentView: SymbolButtonContentView
    private let buttonState: ButtonState
    private let layout: AddConditionViewController.Layout

    // MARK: init/deinit
    internal init(
        state: ButtonState,
        layout: AddConditionViewController.Layout,
        onTap: @escaping (SymbolButton) -> Void
    ) {
        self.buttonState = state
        self.onTap = onTap
        self.contentView = SymbolButtonContentView(
            title: state.title,
            tickColor: state.tickColor,
            valueLabelColor: state.valueLabelColor,
            bgColor: state.backgroundColor,
            layout: layout
        )
        self.layout = layout

        super.init(frame: .zero)

        accessibilityTraits = .button
        setupViews()
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    // MARK: setup
    private func setupViews() {
        add(fullscreenSubview: contentView)
    }

    // MARK: interface actions
    @objc
    private func buttonTapped() {
        onTap(self)
    }
}
