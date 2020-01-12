import RxCocoa
import SnapKit
import Then
import UIKit
import WhatToWearCoreUI
import WhatToWearModels

internal final class UpdateWarningHeaderView: CodeBackedView {
    // MARK: Buttons
    internal enum Button {
        case dismiss
        case appStore
    }

    // MARK: properties
    private lazy var titleLabel = UILabel().then {
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 18, weight: .regular)
        $0.setContentHuggingPriority(.required, for: .vertical)
        $0.setContentCompressionResistancePriority(.required, for: .vertical)

        let format = NSLocalizedString("Update %@ Available", comment: "")

        $0.text = String(
            format: format,
            arguments: [latestUpdate.version.shortStringRepresentation]
        )
    }
    private let buttonContainerView = UIView()
    private lazy var dismissButton = BorderedInsetButton(
        insets: UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10),
        onTap: { [onButtonTap] in
            onButtonTap(.dismiss)
        }
    ).then {
        $0.label.font = .systemFont(ofSize: 15, weight: .regular)
        $0.label.text = NSLocalizedString("Dismiss", comment: "")
    }
    private lazy var appStoreButton = BorderedInsetButton(
        insets: UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10),
        onTap: { [onButtonTap] in
            onButtonTap(.appStore)
        }
    ).then {
        $0.label.font = .systemFont(ofSize: 15, weight: .regular)
        $0.label.text = NSLocalizedString("App Store", comment: "")
    }
    private let bottomSeparatorView = SeparatorView()
    private let latestUpdate: LatestAppUpdate
    private let onButtonTap: (Button) -> Void

    // MARK: init
    internal init(latestUpdate: LatestAppUpdate, onButtonTap: @escaping (Button) -> Void) {
        self.latestUpdate = latestUpdate
        self.onButtonTap = onButtonTap

        super.init(frame: UIScreen.main.bounds)

        self.backgroundColor = UIColor(hex: 0xC5681A)

        setupViews()
    }

    // MARK: setup
    private func setupViews() {
        add(subview: titleLabel, withConstraints: { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
        })

        add(
            subview: buttonContainerView,
            withConstraints: { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
                make.centerX.equalToSuperview()
            },
            subviews: {
                $0.add(subview: dismissButton, withConstraints: { make in
                    make.top.equalToSuperview()
                    make.leading.equalToSuperview()
                    make.bottom.equalToSuperview()
                })

                $0.add(subview: appStoreButton, withConstraints: { make in
                    make.top.equalToSuperview()
                    make.leading.equalTo(dismissButton.snp.trailing).offset(10)
                    make.trailing.equalToSuperview()
                    make.bottom.equalToSuperview()
                    make.size.equalTo(dismissButton)
                })
            }
        )

        add(subview: bottomSeparatorView, withConstraints: { make in
            make.top.equalTo(buttonContainerView.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        })
    }
}
