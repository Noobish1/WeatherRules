import UIKit
import WhatToWearCoreUI

internal final class MeasurementSectionHeaderView: CodeBackedHeaderFooterView {
    // MARK: properties
    private let label = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 20, weight: .bold)
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

        contentView.add(subview: label, withConstraints: { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalToSuperview().offset(10)
        })

        contentView.add(subview: infoButton, withConstraints: { make in
            make.leading.equalTo(label.snp.trailing).offset(6)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(14)
        })

        contentView.add(subview: bottomSeparatorView, withConstraints: { make in
            make.top.equalTo(label.snp.bottom).offset(8)
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

    // MARK: configure
    internal func configure(withTitle title: String) {
        label.text = title
    }
}
