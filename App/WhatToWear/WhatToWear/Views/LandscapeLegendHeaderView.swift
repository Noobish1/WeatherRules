import UIKit
import WhatToWearCoreUI

internal final class LandscapeLegendHeaderView: CodeBackedView {
    // MARK: properties
    private lazy var label = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.text = title
        $0.setContentHuggingPriority(.required, for: .vertical)
    }
    private lazy var bottomSeparatorView = SeparatorView()
    private let title: String
    private let titleInsets: UIEdgeInsets

    // MARK: init
    internal init(title: String, titleInsets: UIEdgeInsets) {
        self.title = title
        self.titleInsets = titleInsets

        super.init(frame: UIScreen.main.bounds)

        setupViews()
    }

    // MARK: setup
    private func setupViews() {
        add(subview: label, withConstraints: { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(titleInsets.left)
            make.trailing.equalToSuperview().inset(titleInsets.right)
        })

        add(subview: bottomSeparatorView, withConstraints: { make in
            make.top.equalTo(label.snp.bottom).offset(titleInsets.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        })
    }
}
