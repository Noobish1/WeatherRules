import SnapKit
import Then
import UIKit
import WhatToWearCoreComponents
import WhatToWearModels

public final class BasicBackgroundView: AppBackgroundView {
    // MARK: properties
    private let leftSeparatorView = SeparatorView()
    private let rightSeparatorView = SeparatorView()

    // MARK: init
    public init() {
        super.init()
        
        setupViews()
    }

    // MARK: setup
    private func setupViews() {
        if #available(iOS 11, *) {
            clipsToBounds = true

            add(leftSeparatorView: leftSeparatorView, onTheRightOf: self.safeAreaLayoutGuide)
            add(rightSeparatorView: rightSeparatorView, onTheLeftOf: self.safeAreaLayoutGuide)
        }
    }
}
