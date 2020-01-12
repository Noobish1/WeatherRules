import SnapKit
import UIKit
import WhatToWearAssets

internal class MultiSelectTableViewCell: TextTableViewCell {
    // MARK: properties
    private let selectionImageView = UIImageView(image: R.image.unselectedRule()).then {
        $0.tintColor = .white
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }

    // MARK: setup
    internal override func setupViews() {
        super.setupViews()

        contentView.add(subview: selectionImageView, withConstraints: { make in
            make.leading.equalTo(titleLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(textInsets.right)
            make.centerY.equalToSuperview()
            make.size.equalTo(30)
        })
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

    // MARK: constraints
    internal override func titleLabelConstraints(
        for make: ConstraintMaker,
        textInsets: UIEdgeInsets
    ) {
        make.top.equalToSuperview().offset(textInsets.top)
        make.leading.equalToSuperview().offset(textInsets.left)
        make.bottom.equalToSuperview().inset(textInsets.bottom + 1)
    }
}
