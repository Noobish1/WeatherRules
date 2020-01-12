import ErrorRecorder
import UIKit
import WhatToWearCoreUI

internal final class PreloadingViewController: CodeBackedViewController {
    // MARK: properties
    private let label = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .white
        $0.text = NSLocalizedString("Release your finger to load", comment: "")
    }

    // MARK: setup
    private func setupViews() {
        view.backgroundColor = .clear

        view.add(subview: label, withConstraints: { make in
            make.center.equalToSuperview()
        })
    }

    // MARK: update constraints
    internal override func updateViewConstraints() {
        if let window = view.window {
            label.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalTo(window)
            }
        }

        super.updateViewConstraints()
    }

    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Analytics.record(screen: .preloading)
    }
}
