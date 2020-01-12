import ErrorRecorder
import SnapKit
import Then
import UIKit
import WhatToWearCoreUI
import WhatToWearModels

internal final class TimeInputViewController: CodeBackedViewController {
    // MARK: properties
    private lazy var contentView = TimeInputContentView(time: initialTime).then {
        $0.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    private let context: UIViewController.Type
    private let onDone: (TimeInputViewController, MilitaryTime) -> Void
    private let initialTime: MilitaryTime

    // MARK: init/deinit
    internal init(
        context: UIViewController.Type,
        time: MilitaryTime,
        onDone: @escaping (TimeInputViewController, MilitaryTime) -> Void
    ) {
        self.context = context
        self.initialTime = time
        self.onDone = onDone

        super.init()
    }

    // MARK: setup
    private func setupViews() {
        view.backgroundColor = Colors.blueButton

        view.add(fullscreenSubview: contentView)
    }

    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        contentView.styleTimePicker()
    }

    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Analytics.record(screen: .timeInput(from: context))
    }

    // MARK: interface actions
    @objc
    private func doneButtonTapped() {
        onDone(self, contentView.timePickerTime())
    }
}
