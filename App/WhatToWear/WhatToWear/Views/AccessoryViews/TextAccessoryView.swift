import UIKit

internal final class TextAccessoryView: AccessoryView {
    // MARK: properties
    private let onDone: (String) -> Void

    // MARK: init
    internal init(title: String, value: String?, onDone: @escaping (String) -> Void) {
        self.onDone = onDone

        super.init(title: title, value: value)
    }

    // MARK: interface actions
    internal override func doneButtonTapped() {
        guard let string = textField.text else {
            textField.flashBackgroundFailureColor()

            return
        }

        textField.resignFirstResponder()

        onDone(string)
    }
}
