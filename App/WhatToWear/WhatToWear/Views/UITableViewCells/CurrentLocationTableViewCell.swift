import SnapKit
import Then
import UIKit
import WhatToWearAssets
import WhatToWearCoreUI

internal final class CurrentLocationTableViewCell: CodeBackedCell, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = CurrentLocationTableViewCell

        case ourselves = "currentLocationCell"
        case label = "label"
        case leftImageView = "leftImageView"
    }

    // MARK: properties
    private let label = UILabel().then {
        $0.textColor = .white
        $0.numberOfLines = 2
        $0.text = NSLocalizedString("Use Current Location", comment: "")
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.label)
    }
    private let leftImageView = UIImageView(image: R.image.myLocationButton()).then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.leftImageView)
    }

    // MARK: setup
    internal override func setupViews() {
        super.setupViews()

        wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.ourselves)
        backgroundColor = .clear
        selectedBackgroundView = DefaultSelectedBackgroundView()

        contentView.add(subview: leftImageView, withConstraints: { make in
            make.leading.equalToSuperview().offset(10)
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
        })

        contentView.add(subview: label, withConstraints: { make in
            make.leading.equalTo(leftImageView.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(10)
        })
    }
}
