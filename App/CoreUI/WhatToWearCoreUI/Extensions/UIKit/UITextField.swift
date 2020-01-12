import UIKit

extension UITextField {
    public func flashBackgroundFailureColor() {
        let originalBackgroundColor = self.backgroundColor

        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [.autoreverse, .curveLinear, .transitionCrossDissolve],
            animations: {
                self.backgroundColor = Colors.failure
            }, completion: { _ in
                self.backgroundColor = originalBackgroundColor
            }
        )
    }
}
