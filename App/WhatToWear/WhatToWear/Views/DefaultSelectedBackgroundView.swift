import UIKit
import WhatToWearCoreUI

internal final class DefaultSelectedBackgroundView: CodeBackedView {
    // MARK: properties
    private let backgroundView = UIView().then {
        $0.backgroundColor = Colors.selectedBackground
    }

    // MARK: init
    internal init() {
        super.init(frame: .zero)

        setupViews()
    }

    // MARK: setup
    private func setupViews() {
        add(subview: backgroundView, withConstraints: { make in
            make.top.equalToSuperview()
            
            // Made these almostRequired because I was getting unsatisfiable constraints on iOS 13
            // When navigating to the LocationsViewController on landscape
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide().priority(.almostRequired)
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide().priority(.almostRequired)
            
            make.bottom.equalToSuperview()
        })
    }
}
