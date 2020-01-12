import ErrorRecorder
import UIKit
import WhatToWearAssets
import WhatToWearCoreUI

internal final class AddExistingRulesEmptyView: CodeBackedView {
    // MARK: properties
    private let containerView = UIView()
    private let centeredView = UIView()
    private let titleLabel = UILabel().then {
        EmptyViewConfigurator.configure(titleLabel: $0)

        $0.text = NSLocalizedString("No Rules", comment: "")
    }
    private let imageView = UIImageView(image: R.image.clipboard()).then {
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
    }
    private let subtitleLabel = UILabel().then {
        EmptyViewConfigurator.configure(subtitle: $0)

        $0.text = NSLocalizedString("You can add a new rule to this rule\ngroup on the previous screen.", comment: "")
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    internal let helpButton = UnderlinedButton(
        title: NSLocalizedString("What are rule groups?", comment: "")
    ).then {
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    private lazy var goBackButton = BottomAnchoredButton(
        bottomInset: self.wtw_bottomSafeInset,
        onTap: self.onGoBack
    ).then {
        $0.update(title: NSLocalizedString("Go Back", comment: ""))
    }

    internal var onGoBack: () -> Void = {}

    // MARK: init
    internal init() {
        super.init(frame: .zero)

        setupViews()
    }

    // MARK: setup
    private func setupViews() {
        add(subview: containerView, withConstraints: { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        })

        containerView.add(
            subview: centeredView,
            withConstraints: { make in
                make.center.equalToSuperview()
            }, subviews: {
                $0.add(subview: titleLabel, withConstraints: { make in
                    make.top.equalToSuperview()
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                })

                $0.add(subview: imageView, withConstraints: { make in
                    make.top.equalTo(titleLabel.snp.bottom).offset(10)
                    make.centerX.equalToSuperview()
                })

                $0.add(subview: subtitleLabel, withConstraints: { make in
                    make.top.equalTo(imageView.snp.bottom).offset(16)
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                })

                $0.add(subview: helpButton, withConstraints: { make in
                    make.top.equalTo(subtitleLabel.snp.bottom).offset(10)
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                    make.bottom.equalToSuperview()
                })
            }
        )

        add(subview: goBackButton, withConstraints: { make in
            make.top.equalTo(containerView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        })
    }

    // MARK: UIView
    internal override func didMoveToSuperview() {
        if superview != nil {
            // This is the best I can do for this event
            Analytics.record(screen: .addExistingRulesEmptyView)
        }
    }

    // MARK: update
    internal func update(bottomInset: CGFloat) {
        goBackButton.update(bottomInset: bottomInset)
    }
}
