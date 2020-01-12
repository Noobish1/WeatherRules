import UIKit

extension UIPickerView {
    internal func setSeparatorColor(_ color: UIColor) {
        if let secondSubview = self.subviews[safe: 1], let thirdSubview = self.subviews[safe: 2] {
            secondSubview.backgroundColor = color
            thirdSubview.backgroundColor = color
        }
    }
}
