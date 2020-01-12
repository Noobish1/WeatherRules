import UIKit

// From https://stackoverflow.com/a/41248703
internal final class CustomInteractivePopRecognizer: NSObject {
    private let navigationController: UINavigationController

    internal init(controller: UINavigationController) {
        self.navigationController = controller
    }
}

extension CustomInteractivePopRecognizer: UIGestureRecognizerDelegate {
    internal func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController.viewControllers.count > 1
    }

    // This is necessary because without it, subviews of your top controller can
    // cancel out your gesture recognizer on the edge.
    internal func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}
