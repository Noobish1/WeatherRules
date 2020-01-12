import SnapKit
import Then
import UIKit
import WhatToWearCore
import WhatToWearCoreUI

internal class TextTableViewCell: CodeBackedCell, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = TextTableViewCell

        case titleLabel = "titleLabel"
    }

    // MARK: properties
    private static var defaultInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

    internal let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
    }
    private let separatorView = SeparatorView()
    internal var textInsets = defaultInsets

    // MARK: setup
    internal override func setupViews() {
        super.setupViews()

        backgroundColor = .clear
        selectedBackgroundView = DefaultSelectedBackgroundView()

        contentView.add(subview: titleLabel, withConstraints: { maker in
            titleLabelConstraints(for: maker, textInsets: textInsets)
        })

        add(subview: separatorView, withConstraints: { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().priority(.almostRequired)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        })
    }

    // MARK: overrides
    internal override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        separatorView.backgroundColor = Colors.separator
    }

    internal override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        separatorView.backgroundColor = Colors.separator
    }

    // MARK: constraints
    internal func titleLabelConstraints(for make: ConstraintMaker, textInsets: UIEdgeInsets) {
        make.top.equalToSuperview().offset(textInsets.top)
        make.leading.equalToSuperview().offset(textInsets.left)
        make.trailing.equalToSuperview().inset(textInsets.right).priority(.almostRequired)
        make.bottom.equalToSuperview().inset(textInsets.bottom + 1)
    }

    // MARK: configuration
    internal func configure(withText text: String, insets: UIEdgeInsets = defaultInsets) {
        titleLabel.text = text
        textInsets = insets

        updateTitleLabel(withText: text)
    }

    internal func configure(
        withText text: NSAttributedString,
        insets: UIEdgeInsets = defaultInsets
    ) {
        titleLabel.attributedText = text
        textInsets = insets

        updateTitleLabel(withText: text.string)
    }

    // MARK: update
    private func updateTitleLabel(withText text: String) {
        titleLabel.accessibilityIdentifier = "\(AccessibilityIdentifiers.titleLabel.stringValue):\(text)"

        titleLabel.snp.updateConstraints { maker in
            titleLabelConstraints(for: maker, textInsets: textInsets)
        }
    }
}
