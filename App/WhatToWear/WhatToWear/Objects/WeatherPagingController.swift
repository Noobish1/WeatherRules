import UIKit
import WhatToWearCoreUI

// MARK: WeatherPagingController
internal final class WeatherPagingController: NSObject, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = WeatherPagingController

        case scrollView = "scrollView"
    }

    // MARK: properties
    internal weak var pagingDelegate: WeatherPagingControllerDelegate?
    internal lazy var scrollView = UIScrollView().then {
        $0.isPagingEnabled = true
        $0.delegate = self
        $0.showsHorizontalScrollIndicator = false
        $0.isDirectionalLockEnabled = true
        $0.alwaysBounceVertical = false
        $0.delaysContentTouches = false
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.scrollView)
    }
    internal var currentPage: Int = 0

    // MARK: scrolling
    internal func scrollToCurrentPage(animated: Bool, force: Bool = false, completion: (() -> Void)? = nil) {
        scrollTo(page: currentPage, animated: animated, force: force, completion: completion)
    }
    
    internal func scrollTo(page: Int, animated: Bool, force: Bool = false, completion: (() -> Void)? = nil) {
        guard force || page != currentPage else { return }

        let actualCompletion = {
            self.movedToPage(page: page)

            completion?()
        }

        if animated {
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    self.scrollView.setContentOffset(
                        CGPoint(x: self.scrollView.frame.width * CGFloat(page), y: 0),
                        animated: false
                    )
                },
                completion: { _ in
                    actualCompletion()
                }
            )
        } else {
            self.scrollView.contentOffset = CGPoint(
                x: self.scrollView.frame.width * CGFloat(page),
                y: 0
            )

            actualCompletion()
        }
    }

    // MARK: moving pages
    private func movedToPage(page: Int) {
        pagingDelegate?.pagingController(self, didMoveToPage: page)
    }
}

// MARK: UIScrollViewDelegate
extension WeatherPagingController: UIScrollViewDelegate {
    internal func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            movedToPage(page: scrollView.currentPage)
        }
    }

    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        movedToPage(page: scrollView.currentPage)
    }
}
