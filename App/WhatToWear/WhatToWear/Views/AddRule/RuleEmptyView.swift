import UIKit
import WhatToWearAssets
import WhatToWearCoreUI

internal final class RuleEmptyView: CodeBackedView {
    // MARK: Config
    internal struct Config {
        internal let title: String
        internal let subtitle: String
        internal let helpButtonTitle: String
        
        internal static var addRule: Self {
            return Config(
                title: NSLocalizedString("No Added Conditions", comment: ""),
                subtitle: NSLocalizedString("You can add a new condition below.", comment: ""),
                helpButtonTitle: NSLocalizedString("What are conditions?", comment: "")
            )
        }
        
        internal static var addRuleGroup: Self {
            return Config(
                title: NSLocalizedString("No Added Rules", comment: ""),
                subtitle: NSLocalizedString("You can add a new rule or\nexisting rule below.", comment: ""),
                helpButtonTitle: NSLocalizedString("What are rule groups?", comment: "")
            )
        }
        
        internal static var rules: Self {
            return Config(
                title: NSLocalizedString("No Rules", comment: ""),
                subtitle: NSLocalizedString("You can add a new rule below.", comment: ""),
                helpButtonTitle: NSLocalizedString("What are rules?", comment: "")
            )
        }
    }
    
    // MARK: properties
    private let navBarSeparatorView = SeparatorView()
    private let centeredView = UIView()
    private lazy var titleLabel = UILabel().then {
        EmptyViewConfigurator.configure(titleLabel: $0)

        $0.text = config.title
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    private let imageView = UIImageView(image: R.image.clipboard()).then {
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
    }
    private lazy var subtitleLabel = UILabel().then {
        EmptyViewConfigurator.configure(subtitle: $0)

        $0.text = config.subtitle
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    internal lazy var helpButton = UnderlinedButton(
        title: config.helpButtonTitle
    ).then {
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    private let config: Config

    // MARK: init
    internal init(config: Config) {
        self.config = config
        
        super.init(frame: .zero)

        setupViews()
    }

    // MARK: setup
    private func setupViews() {
        add(topSeparatorView: navBarSeparatorView)

        add(
            subview: centeredView,
            withConstraints: { make in
                make.center.equalToSuperview()
                make.leading.greaterThanOrEqualToSuperview().offset(30)
                make.trailing.lessThanOrEqualToSuperview().inset(30)
                make.top.greaterThanOrEqualToSuperview().offset(30)
                make.bottom.lessThanOrEqualToSuperview().inset(30)
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
                    make.centerX.equalToSuperview()
                    make.bottom.equalToSuperview()
                })
            }
        )
    }
}
