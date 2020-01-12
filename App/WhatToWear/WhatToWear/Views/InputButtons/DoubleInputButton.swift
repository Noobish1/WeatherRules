import Then
import UIKit
import WhatToWearCoreUI
import WhatToWearModels

// MARK: DoubleInputButton
internal final class DoubleInputButton: InputButton {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = DoubleInputButton

        case ourAccessoryView = "ourAccessoryView"
    }

    // MARK: properties
    internal override var ourAccessoryView: UIView {
        return ourActualAccessoryView
    }

    private lazy var ourActualAccessoryView = DoubleAccessoryView(
        rawValue: initialRawValue,
        measurement: measurement,
        system: system,
        onDone: { [unowned self] newDisplayedValue in
            self.onDone(newDisplayedValue)
            self.resignFirstResponder()
        }
    ).then {
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.ourAccessoryView)
    }
    private let measurement: DoubleMeasurement
    private let system: MeasurementSystem
    private let onDone: (DisplayedValue) -> Void
    private let initialRawValue: Double?

    // MARK: init/deinit
    internal init(
        rawValue: Double?,
        measurement: DoubleMeasurement,
        system: MeasurementSystem,
        layout: AddConditionViewController.Layout,
        onDone: @escaping (DisplayedValue) -> Void
    ) {
        self.initialRawValue = rawValue
        self.measurement = measurement
        self.system = system
        self.onDone = onDone

        let displayedValueWithUnits = rawValue.map {
            DoubleMeasurementViewModel.displayedStringValueWithUnits(for: measurement, rawValue: $0, system: system)
        }

        super.init(
            state: .init(value: displayedValueWithUnits),
            layout: layout,
            defaultValue: NSLocalizedString("Value", comment: "")
        )
    }
}
