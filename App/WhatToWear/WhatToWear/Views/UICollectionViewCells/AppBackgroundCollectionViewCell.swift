import UIKit
import WhatToWearCoreUI
import WhatToWearModels

internal class AppBackgroundCollectionViewCell: UICollectionViewCell {
    // MARK: properties
    private var ourBackgroundView: AppBackgroundView?

    internal override var isSelected: Bool {
        willSet {
            updateSelectionStyle(for: ourBackgroundView, selection: isHighlighted || newValue)
        }
    }

    internal override var isHighlighted: Bool {
        willSet {
            updateSelectionStyle(for: ourBackgroundView, selection: newValue || isSelected)
        }
    }

    // MARK: update
    private func updateSelectionStyle(for view: AppBackgroundView?, selection: Bool) {
        if selection {
            view?.layer.borderColor = Colors.blueButton.cgColor
            view?.layer.borderWidth = 3.0
        } else {
            view?.layer.borderColor = UIColor.white.cgColor
            view?.layer.borderWidth = 1.0
        }
    }

    // MARK: configure
    internal func configure(with option: AppBackgroundOptions) {
        ourBackgroundView?.removeFromSuperview()

        let newBackgroundView = AppBackgroundView(option: option, observeChanges: false)

        updateSelectionStyle(for: newBackgroundView, selection: isHighlighted || isSelected)

        contentView.add(subview: newBackgroundView, withConstraints: { make in
            make.edges.equalToSuperview()
        })

        ourBackgroundView = newBackgroundView
    }
}
