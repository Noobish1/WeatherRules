import SnapKit
import Then
import UIKit
import WhatToWearCoreComponents
import WhatToWearCoreUI
import WhatToWearModels

public final class WhatsNewTableViewCell: CodeBackedCell {
    // MARK: properties
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.font = .boldSystemFont(ofSize: 17)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    private let subtitleLabel = UILabel().then {
        $0.textColor = UIColor.white.darker(by: 15.percent)
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 15)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    private let separatorView = SeparatorView()

    // MARK: setup
    public override func setupViews() {
        super.setupViews()

        backgroundColor = .clear

        contentView.add(subview: titleLabel, withConstraints: { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
        })

        contentView.add(subview: subtitleLabel, withConstraints: { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
        })

        contentView.add(subview: separatorView, withConstraints: { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        })
    }

    // MARK: configuration
    public func configure(with segment: WhatsNewSegmentViewModel) {
        titleLabel.text = segment.title
        subtitleLabel.text = segment.subtitle
    }
}
