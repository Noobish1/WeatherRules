import SnapKit
import Then
import UIKit
import WhatToWearCoreUI

internal final class BasicSectionHeaderView: CodeBackedHeaderFooterView {
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
            $0.backgroundColor = Colors.headerBackground
        }

        contentView.add(subview: label, withConstraints: { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
        })

        contentView.add(subview: bottomSeparatorView, withConstraints: { make in
            make.top.equalTo(label.snp.bottom).offset(4)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        })
    }

    // MARK: configuration
    internal func configure(withTitle title: String) {
        label.text = title
    }
}
