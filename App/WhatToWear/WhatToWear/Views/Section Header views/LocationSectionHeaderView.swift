import SnapKit
import Then
import UIKit
import WhatToWearCoreUI

internal final class LocationSectionHeaderView: CodeBackedHeaderFooterView {
    // MARK: properties
    internal let label = UILabel().then {
        $0.textColor = .white
        $0.font = .boldSystemFont(ofSize: 18)
    }
    private let bottomSeparatorView = SeparatorView()

    // MARK: setup
    internal override func setupViews() {
        super.setupViews()

        backgroundView = UIView().then {
            $0.backgroundColor = .clear
        }

        contentView.add(subview: label, withConstraints: { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
        })

        contentView.add(subview: bottomSeparatorView, withConstraints: { make in
            make.top.equalTo(label.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        })
    }

    // MARK: configuration
    internal func configure(with section: LocationSelectionViewController.Section) {
        label.text = section.sectionTitle
    }
}
