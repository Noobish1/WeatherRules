import KeyboardObserver
import SnapKit
import UIKit

private typealias TransitionAnimation = ((UIViewControllerTransitionCoordinatorContext?) -> Void)
private typealias TransitionCompletion = ((UIViewControllerTransitionCoordinatorContext?) -> Void)

public final class DimmedPresentationController: UIPresentationController {
    // MARK: constants
    private let endAlpha: CGFloat = 0.4

    // MARK: properties
    private let dimmingView = UIView()
    private let tapRecognizer = UITapGestureRecognizer()
    private let keyboardObserver = KeyboardObserver().then {
        $0.isEnabled = false
    }
    public var onTapToDismiss: (() -> Void)?
    public var shouldObserveKeyboardFrameChanges = false {
        didSet {
            keyboardObserver.isEnabled = shouldObserveKeyboardFrameChanges
        }
    }

    // MARK: overrides
    public override var shouldPresentInFullscreen: Bool {
        return false
    }

    // MARK: init/deinit
    public override init(
        presentedViewController: UIViewController,
        presenting presentingViewController: UIViewController?
    ) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        self.dimmingView.backgroundColor = .black
        self.dimmingView.alpha = 0
        self.dimmingView.isUserInteractionEnabled = true
        self.dimmingView.addGestureRecognizer(self.tapRecognizer)

        self.tapRecognizer.addTarget(self, action: #selector(handleTap(_:)))

        self.keyboardObserver.observe { [weak self] event in
            guard let strongSelf = self else { return }

            switch event.type {
                case .willChangeFrame: strongSelf.performKeyboardHandling(event)
                default: break
            }
        }
    }

    deinit {
        self.dimmingView.removeGestureRecognizer(self.tapRecognizer)
    }

    // MARK: gestures
    @objc
    internal func handleTap(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            if let onTapToDismiss = onTapToDismiss {
                onTapToDismiss()
            } else {
                self.presentingViewController.dismiss(animated: true, completion: nil)
            }
        }
    }

    // MARK: transition
    public override func presentationTransitionWillBegin() {
        guard let containerView = self.containerView else {
            fatalError("No containerView found for DimmedPresentationController")
        }

        self.dimmingView.frame = containerView.bounds
        self.dimmingView.alpha = 0

        containerView.insertSubview(self.dimmingView, at: 0)

        self.dimmingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let animation: TransitionAnimation = { _ in self.dimmingView.alpha = self.endAlpha }

        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: animation, completion: nil)
        } else {
            animation(nil)
        }
    }

    public override func dismissalTransitionWillBegin() {
        let animation: TransitionAnimation = { _ in self.dimmingView.alpha = 0 }
        let completion: TransitionCompletion = { _ in self.dimmingView.removeFromSuperview() }

        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: animation, completion: completion)
        } else {
            animation(nil)
            completion(nil)
        }
    }

    private func performKeyboardHandling(_ event: KeyboardEvent) {
        guard let containerView = self.containerView else {
            fatalError("No containerView found for DimmedPresentationController")
        }

        let convertedEndFrame = containerView.convert(event.keyboardFrameEnd, from: containerView.window)
        let keyboardOverlap = max(0, containerView.frame.maxY - convertedEndFrame.origin.y)

        var containerRect = self.presentingViewController.view.bounds
        containerRect.size.height -= keyboardOverlap

        UIView.animate(
            withDuration: event.duration,
            delay: 0,
            options: [event.options],
            animations: {
                containerView.frame = containerRect
                containerView.layoutIfNeeded()
            }
        )
    }
}
