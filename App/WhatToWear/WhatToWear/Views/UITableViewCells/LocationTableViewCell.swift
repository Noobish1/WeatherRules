import MapKit
import SnapKit
import Then
import UIKit
import WhatToWearCoreUI
import WhatToWearModels

internal final class LocationTableViewCell: CodeBackedCell, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = LocationTableViewCell

        case label = "label"
    }

    // MARK: properties
    private let label = UILabel().then {
        $0.textColor = .white
        $0.numberOfLines = 2
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.label)
    }

    // MARK: setup
    internal override func setupViews() {
        super.setupViews()

        backgroundColor = .clear
        selectedBackgroundView = DefaultSelectedBackgroundView()

        contentView.add(subview: label, withConstraints: { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(10)
        })
    }

    // MARK: configuration
    internal func configure(with suggestion: MKLocalSearchCompletion) {
        accessibilityIdentifier = "suggestionCell:\(suggestion.title)"
        label.text = suggestion.title
    }

    internal func configure(with validLocation: ValidLocation) {
        accessibilityIdentifier = "validLocationCell:\(validLocation.address ?? "No Textual Address")"
        label.text = validLocation.address
    }
}
