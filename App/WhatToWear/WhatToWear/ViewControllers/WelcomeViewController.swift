import ErrorRecorder
import SnapKit
import Then
import UIKit
import WhatToWearCoreUI
import WhatToWearModels

internal final class WelcomeViewController: CodeBackedViewController, NavStackEmbedded {
    // MARK: properties
    private let gradientView = AppBackgroundView()
    private lazy var contentView = WelcomeContentView(onCallToActionTapped: { [weak self] in
        self?.callToActionButtonTapped()
    })
    private let onLocationSelection: (ValidLocation) -> Void

    // MARK: init
    internal init(onLocationSelection: @escaping (ValidLocation) -> Void) {
        self.onLocationSelection = onLocationSelection

        super.init()
    }

    // MARK: setup
    private func setupViews() {
        view.add(fullscreenSubview: gradientView)

        view.add(fullscreenSubview: contentView)
    }

    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Analytics.record(screen: .welcome)
    }

    // MARK: interface actions
    @objc
    private func callToActionButtonTapped() {
        let vc = LocationSelectionViewController(
            context: .welcomeScreen,
            onSelection: onLocationSelection
        )

        switch InterfaceIdiom.current {
            case .phone:
                navController.pushViewController(vc, animated: true)
            case .pad:
                let navVC = UINavigationController(rootViewController: vc)
                navVC.setNavigationBarHidden(true, animated: false)
                navVC.modalPresentationStyle = .formSheet
            
                present(navVC, animated: true)
        }
    }
}
