import UIKit

extension UIDatePicker {
    internal func setSeparatorColor(_ color: UIColor) {
        if let secondSubview = self.subviews.first?.subviews[safe: 1], let thirdSubview = self.subviews.first?.subviews[safe: 2] {
            secondSubview.backgroundColor = color
            thirdSubview.backgroundColor = color
        }
    }
}
