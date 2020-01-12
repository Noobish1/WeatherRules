import SnapKit
import Then
import UIKit
import WhatToWearCoreUI

internal class RuleTableViewCell: CodeBackedCell {
    // MARK: properties
    internal let nameLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .boldSystemFont(ofSize: 15)
        $0.numberOfLines = 0
    }
    internal let bottomSeparatorView = SeparatorView()

    // MARK: init
    internal override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectedBackgroundView = DefaultSelectedBackgroundView()
    }

    // MARK: setup
    internal override func setupViews() {
        // We don't call super as super does nothing

        contentView.add(subview: nameLabel, withConstraints: { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
        })

        contentView.add(subview: bottomSeparatorView, withConstraints: { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        })
    }

    // MARK: overrides
    internal override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        bottomSeparatorView.backgroundColor = Colors.separator
    }

    internal override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        bottomSeparatorView.backgroundColor = Colors.separator
    }

    // MARK: configuration
    internal func configure(with viewModel: RuleViewModel) {
        nameLabel.text = viewModel.title
    }
}
