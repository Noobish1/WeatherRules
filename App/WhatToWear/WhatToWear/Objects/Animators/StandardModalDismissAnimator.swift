import Foundation
import SnapKit
import UIKit

internal final class StandardModalDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    internal func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        return AnimationDuration.shortMedium.value
    }

    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) else {
            fatalError("Could not find presentingViewController for StandardModalDismissAnimator")
        }
        guard let toVC = transitionContext.viewController(forKey: .to) else {
            fatalError("Could not find presentedViewController for StandardModalDismissAnimator")
        }
        let containerView = transitionContext.containerView

        self.dismissViewController(toVC, fromVC: fromVC, containerView: containerView, context: transitionContext)
    }

    private func dismissViewController(
        _ toVC: UIViewController,
        fromVC: UIViewController,
        containerView: UIView,
        context: UIViewControllerContextTransitioning
    ) {
        fromVC.view.snp.remakeConstraints { make in
            StandardModalPresentAnimator.mainPresenterConstraintMake(make)
            make.top.equalTo(containerView.snp.bottom)
        }

        UIView.animate(
            withDuration: self.transitionDuration(using: context),
            animations: {
                containerView.layoutIfNeeded()
            },
            completion: { finished in
                context.completeTransition(finished)
            }
        )
    }
}
