import SnapKit
import Then
import UIKit

internal final class ConditionTableViewCell: TextTableViewCell {
    // MARK: setup
    internal override func setupViews() {
        super.setupViews()

        titleLabel.numberOfLines = 0
    }

    // MARK: configuration
    internal func configure(with viewModel: ConditionViewModel) {
        configure(withText: viewModel.title)
    }
}
