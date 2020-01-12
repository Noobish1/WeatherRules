import SnapKit
import Then
import UIKit
import WhatToWearCoreUI
import WhatToWearModels

internal final class MeasurementButton: CodeBackedControl {
    // MARK: ButtonState
    internal enum ButtonState: Equatable {
        case noSelection
        case selected(WeatherMeasurement, system: MeasurementSystem)
        case highlightNoSelection

        // MARK: computed properties
        internal var valueLabelColor: UIColor {
            switch self {
                case .noSelection: return Colors.blueButton
                case .selected: return .yellow
                case .highlightNoSelection: return .white
            }
        }

        internal var backgroundColor: UIColor {
            switch self {
                case .noSelection: return .clear
                case .selected: return Colors.completed
                case .highlightNoSelection: return Colors.failure
            }
        }

        internal var selectedBackgroundColor: UIColor {
            switch self {
                case .noSelection: return Colors.selectedBackground
                case .selected: return Colors.completed.darker(by: 20.percent)
                case .highlightNoSelection: return Colors.failure.darker(by: 20.percent)
            }
        }

        internal var tickColor: UIColor {
            switch self {
                case .noSelection: return .clear
                case .selected: return .white
                case .highlightNoSelection: return .clear
            }
        }

        internal var value: String {
            switch self {
                case .noSelection, .highlightNoSelection:
                    return NSLocalizedString("Measurement", comment: "")
                case .selected(let measurement, system: let system):
                    return WeatherMeasurementViewModel.title(for: measurement, system: system)
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
    private let contentView: MeasurementButtonContentView
    private var buttonState: MeasurementButton.ButtonState = .noSelection

    // MARK: init/deinit
    internal init(layout: AddConditionViewController.Layout) {
        self.contentView = MeasurementButtonContentView(layout: layout, buttonState: buttonState)

        super.init(frame: .zero)

        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        accessibilityTraits = .button

        setupViews()
        transition(to: buttonState, force: true)
    }

    // MARK: setup
    private func setupViews() {
        add(fullscreenSubview: contentView)
    }

    // MARK: transition
    internal func transition(to newButtonState: ButtonState, force: Bool = false) {
        guard force || newButtonState != buttonState else { return }

        contentView.transition(to: newButtonState)

        self.buttonState = newButtonState
    }
}
