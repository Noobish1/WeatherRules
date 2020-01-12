import SnapKit
import UIKit
import WhatToWearAssets

internal final class DetailTableViewCell: TextTableViewCell {
    // MARK: properties
    private let customAccessoryView = UIImageView(image: R.image.disclosureIndicator()).then {
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
    }
    
    // MARK: setup
    internal override func setupViews() {
        super.setupViews()

        contentView.add(subview: customAccessoryView, withConstraints: { make in
            make.leading.equalTo(titleLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(textInsets.right)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 9, height: 13))
        })
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
