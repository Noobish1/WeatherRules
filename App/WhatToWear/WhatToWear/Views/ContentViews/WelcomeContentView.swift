import UIKit
import WhatToWearCoreUI

internal final class WelcomeContentView: CodeBackedView, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = WelcomeContentView

        case welcomeLabel = "welcomeLabel"
        case callToActionButton = "callToActionButton"
    }
    
    // MARK: properties
    private let centeredView = UIView()
    private let welcomeLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 50)
        $0.text = NSLocalizedString("Welcome", comment: "")
        $0.textAlignment = .center
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.welcomeLabel)
    }
    private lazy var callToActionButton = UIButton(type: .system).then {
        $0.setTitle(NSLocalizedString("First we'll need a location →", comment: ""), for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 20)
        $0.titleLabel?.textAlignment = .center
        $0.addTarget(self, action: #selector(callToActionButtonTapped), for: .touchUpInside)
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.callToActionButton)
    }
    private let onCallToActionTapped: () -> Void
    
    // MARK: init
    internal init(onCallToActionTapped: @escaping () -> Void) {
        self.onCallToActionTapped = onCallToActionTapped
        
        super.init(frame: .zero)
        
        setupViews()
    }
    
    // MARK: setup
    private func setupViews() {
        add(
            subview: centeredView,
            withConstraints: { make in
                make.leading.greaterThanOrEqualToSuperview()
                make.trailing.lessThanOrEqualToSuperview()
                make.center.equalToSuperview()
            },
            subviews: { container in
                container.add(subview: welcomeLabel, withConstraints: { make in
                    make.top.equalToSuperview()
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                    make.centerX.equalToSuperview()
                })

                container.add(subview: callToActionButton, withConstraints: { make in
                    make.top.equalTo(welcomeLabel.snp.bottom).offset(20)
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                    make.bottom.equalToSuperview()
                    make.centerX.equalToSuperview()
                })
            }
        )
    }
    
    // MARK: interface actions
    @objc
    private func callToActionButtonTapped() {
        onCallToActionTapped()
    }
}
