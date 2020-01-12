import UIKit
import WhatToWearAssets

internal final class ExistingRuleTableViewCell: RuleTableViewCell {
    // MARK: properties
    private let selectionImageView = UIImageView(image: R.image.unselectedRule()).then {
        $0.tintColor = .white
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }
    private let leftView = UIView()
    private let rightView = UIView()

    // MARK: setup
    internal override func setupViews() {
        super.setupViews()

        contentView.add(subview: leftView, withConstraints: { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(10)
        })

        leftView.add(subview: nameLabel, withConstraints: { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        })

        contentView.add(subview: rightView, withConstraints: { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(10)
            make.leading.equalTo(leftView.snp.trailing).offset(10)
        })

        rightView.add(subview: selectionImageView, withConstraints: { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(30)
        })

        contentView.add(subview: bottomSeparatorView, withConstraints: { make in
            make.top.equalTo(leftView.snp.bottom).offset(20)
            make.top.equalTo(rightView.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        })
    }

    // MARK: reuse
    internal override func prepareForReuse() {
        super.prepareForReuse()

        selectionImageView.image = R.image.unselectedRule()
    }

    // MARK: selection
    internal override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            selectionImageView.image = R.image.selectedRule()
        } else {
            selectionImageView.image = R.image.unselectedRule()
        }
    }
}
