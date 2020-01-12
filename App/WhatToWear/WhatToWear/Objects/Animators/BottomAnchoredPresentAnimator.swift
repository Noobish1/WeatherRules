import SnapKit
import UIKit

internal final class BottomAnchoredPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    internal func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return AnimationDuration.shortMedium.value
    }

    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) else {
            fatalError("Could not find presentingViewController for the BottomAnchoredPresentAnimator")
        }
        guard let toVC = transitionContext.viewController(forKey: .to) else {
            fatalError("Could not find presentedViewController for the BottomAnchoredPresentAnimator")
        }
        let containerView = transitionContext.containerView

        self.present(
            toVC,
            fromVC: fromVC,
            containerView: containerView,
            context: transitionContext
        )
    }

    private func present(
        _ toVC: UIViewController,
        fromVC: UIViewController,
        containerView: UIView,
        context: UIViewControllerContextTransitioning
    ) {
        containerView.addSubview(toVC.view)

        var topConstraint: Constraint?

        toVC.view.snp.makeConstraints { make in
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
            topConstraint = make.top.equalTo(containerView.snp.bottom).constraint
        }

        containerView.layoutIfNeeded()

        topConstraint?.deactivate()

        toVC.view.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.equalTo(containerView)
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
