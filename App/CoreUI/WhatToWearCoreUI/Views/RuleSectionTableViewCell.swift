import SnapKit
import Then
import UIKit
import WhatToWearCoreComponents

public final class RuleSectionTableViewCell: CodeBackedCell {
    // MARK: properties
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .boldSystemFont(ofSize: 15)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    private let subtitleLabel = UILabel().then {
        $0.textColor = .white
        $0.numberOfLines = 2
        $0.font = .systemFont(ofSize: 13)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    private let separatorView = SeparatorView()

    // MARK: setup
    public override func setupViews() {
        super.setupViews()

        backgroundColor = .clear

        contentView.add(subview: titleLabel, withConstraints: { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().inset(12)
        })

        contentView.add(subview: subtitleLabel, withConstraints: { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().inset(12)
        })

        contentView.add(subview: separatorView, withConstraints: { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        })
    }

    // MARK: configuration
    public func configure(with viewModel: RuleSectionViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
}
