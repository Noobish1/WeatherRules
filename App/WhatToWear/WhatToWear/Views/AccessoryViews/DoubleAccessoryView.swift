import UIKit
import WhatToWearCore
import WhatToWearModels

internal final class DoubleAccessoryView: AccessoryView {
    // MARK: properties
    private let viewModel: DoubleAccessoryViewModel
    private let onDone: (DisplayedValue) -> Void

    // MARK: init/deinit
    internal init(
        rawValue: Double?,
        measurement: DoubleMeasurement,
        system: MeasurementSystem,
        onDone: @escaping (DisplayedValue) -> Void
    ) {
        let viewModel = DoubleAccessoryViewModel(measurement: measurement, system: system)
        
        self.viewModel = viewModel
        self.onDone = onDone

        let title = viewModel.title
        let displayedValue = viewModel.displayedValueString(for: rawValue)

        super.init(title: title, value: displayedValue)

        // This is apparently slow when using just .decimalPad
        textField.keyboardType = UIKeyboardType.decimalPad
    }

    // MARK: interface actions
    @objc
    internal override func doneButtonTapped() {
        guard let displayedValue = viewModel.displayedValue(fromTextFieldText: textField.text) else {
            textField.flashBackgroundFailureColor()

            return
        }

        textField.resignFirstResponder()

        onDone(displayedValue)
    }
}
