import KeyboardObserver
import UIKit

// MARK: general
extension UIViewController {
    // MARK: keyboard handling
    internal func performDefaultKeyboardHandling(for event: KeyboardEvent, scrollView: UIScrollView) {
        switch event.type {
            case .willShow, .willHide, .willChangeFrame:
                let convertedEndFrame = view.convert(event.keyboardFrameEnd, from: view.window)
                let keyboardOverlap = max(0, scrollView.frame.maxY - convertedEndFrame.origin.y)

                UIView.animate(
                    withDuration: event.duration,
                    delay: 0,
                    options: [event.options],
                    animations: {
                        scrollView.contentInset.bottom = keyboardOverlap
                        scrollView.scrollIndicatorInsets.bottom = keyboardOverlap
                    }
                )
            case .didShow, .didHide, .didChangeFrame:
                break
        }
    }
}
