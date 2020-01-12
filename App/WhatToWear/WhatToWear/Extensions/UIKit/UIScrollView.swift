import UIKit

extension UIScrollView {
    internal var currentPage: Int {
        return Int((contentOffset.x + (0.5 * frame.width)) / frame.width)
    }
}
