import Foundation
import SnapKit
import UIKit

internal final class StandardModalPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    internal static func mainPresenterConstraintMake(_ make: ConstraintMaker) {
        make.leading.greaterThanOrEqualToSuperview().offset(25).priority(751)
        make.trailing.lessThanOrEqualToSuperview().inset(25).priority(751)
        make.width.greaterThanOrEqualTo(500).priority(750)
        make.centerX.equalToSuperview()
    }

    internal func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        return AnimationDuration.shortMedium.value
    }

    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) else {
            fatalError("Could not find presentingViewController for the StandardModalPresentAnimator")
        }
        guard let toVC = transitionContext.viewController(forKey: .to) else {
            fatalError("Could not find presentedViewController for the StandardModalPresentAnimator")
        }
        let containerView = transitionContext.containerView

        self.present(toVC, fromVC: fromVC, containerView: containerView, context: transitionContext)
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
            StandardModalPresentAnimator.mainPresenterConstraintMake(make)
            topConstraint = make.top.equalTo(containerView.snp.bottom).constraint
        }

        containerView.layoutIfNeeded()

        topConstraint?.deactivate()

        toVC.view.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview().offset(25)
            make.bottom.lessThanOrEqualToSuperview().inset(25)
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
