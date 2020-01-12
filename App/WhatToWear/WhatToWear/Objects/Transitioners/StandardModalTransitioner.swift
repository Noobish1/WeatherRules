import Foundation
import UIKit

public final class StandardModalTransitioner: NSObject, UIViewControllerTransitioningDelegate {
    private let allowsTapToDismiss: Bool

    public init(allowsTapToDismiss: Bool = true) {
        self.allowsTapToDismiss = allowsTapToDismiss

        super.init()
    }

    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return StandardModalPresentAnimator()
    }

    public func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return StandardModalDismissAnimator()
    }

    public func interactionControllerForPresentation(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }

    public func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }

    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        let dimmed = DimmedPresentationController(
            presentedViewController: presented, presenting: presenting
        )
        dimmed.onTapToDismiss = allowsTapToDismiss ? nil : { }

        return dimmed
    }
}
