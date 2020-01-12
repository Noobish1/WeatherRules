import UIKit

extension UIView {
    internal var wtw_bottomSafeInset: CGFloat {
        if #available(iOS 11, *) {
            return self.safeAreaInsets.bottom
        } else {
            return 0
        }
    }
}
