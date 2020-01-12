import UIKit
import WhatToWearCoreUI

internal final class RuleGroupHeaderView: CodeBackedHeaderFooterView {
    // MARK: properties
    private let labelsContainerView = UIView()
    private let nameLabel = UILabel().then {
        $0.textColor = .white
        $0.text = NSLocalizedString("Name", comment: "")
    }
    private let priorityLabel = UILabel().then {
        $0.textColor = .white
        $0.text = NSLocalizedString("Priority", comment: "")
    }
    private lazy var infoButton = InfoButton().then {
        $0.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
    }
    private let bottomSeparatorView = SeparatorView()
    internal var onInfoButtonTapped: (() -> Void)?

    // MARK: prepare
    internal override func prepareForReuse() {
        super.prepareForReuse()

        onInfoButtonTapped = nil
    }

    // MARK: setup
    internal override func setupViews() {
        super.setupViews()

        backgroundView = UIView().then {
            $0.backgroundColor = Colors.headerBackground
        }

        contentView.add(
            subview: labelsContainerView,
            withConstraints: { make in
                make.top.equalToSuperview().offset(8)
                make.leading.equalToSuperview().offset(48)
            }, subviews: {
                $0.add(subview: nameLabel, withConstraints: { make in
                    make.top.equalToSuperview()
                    make.leading.equalToSuperview()
                    make.bottom.equalToSuperview()
                })

                $0.add(subview: priorityLabel, withConstraints: { make in
                    make.top.equalToSuperview()
                    make.leading.greaterThanOrEqualTo(nameLabel.snp.trailing)
                    make.trailing.equalToSuperview()
                    make.bottom.equalToSuperview()
                })
            }
        )

        contentView.add(subview: infoButton, withConstraints: { make in
            make.leading.equalTo(labelsContainerView.snp.trailing).offset(6)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(14)
        })

        contentView.add(subview: bottomSeparatorView, withConstraints: { make in
            make.top.equalTo(labelsContainerView.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        })
    }

    // MARK: interface actions
    @objc
    private func infoButtonTapped() {
        onInfoButtonTapped?()
    }
}
