import SnapKit
import Then
import UIKit
import WhatToWearCoreComponents
import WhatToWearCoreUI

internal final class MeasurementTableViewCell: CodeBackedCell {
    // MARK: properties
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .boldSystemFont(ofSize: 17)
    }
    private let subtitleLabel = UILabel().then {
        $0.textColor = UIColor.white.darker(by: 20.percent)
        $0.numberOfLines = 2
        $0.font = .systemFont(ofSize: 15)
    }
    private let separatorView = SeparatorView()

    // MARK: setup
    internal override func setupViews() {
        super.setupViews()

        backgroundColor = .clear
        selectedBackgroundView = DefaultSelectedBackgroundView()

        contentView.add(subview: titleLabel, withConstraints: { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
        })

        contentView.add(subview: subtitleLabel, withConstraints: { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(8 + 1)
        })

        contentView.add(subview: separatorView, withConstraints: { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
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

    // MARK: configuration
    internal func configure(with viewModel: WeatherMeasurementViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.explanation
    }
}
