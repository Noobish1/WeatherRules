import ErrorRecorder
import RxCocoa
import RxRelay
import RxSwift
import SnapKit
import UIKit
import WhatToWearCore
import WhatToWearCoreComponents
import WhatToWearCoreUI
import WhatToWearModels

internal final class TimeSettingsViewController: CodeBackedViewController, TimeSelectionRequesterProtocol, Accessible, BottomAnchoredInnerViewControllerProtocol {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = TimeSettingsViewController

        case contentView = "contentView"
    }

    // MARK: properties
    private lazy var contentView = TimeSettingsContentView(
        timeSettings: viewModel.timeSettings,
        onFromTap: { [weak self] view, timeRange in
            self?.fromTimeRangeButtonTapped(in: view, timeRange: timeRange)
        },
        onToTap: { [weak self] view, timeRange in
            self?.toTimeRangeButtonTapped(in: view, timeRange: timeRange)
        },
        onIntervalChange: { [viewModel] newInterval in
            viewModel.updateTimeSettings(with: newInterval)
        },
        onIntervalInfoTapped: { [weak self] in
            self?.intervalInfoButtonTapped()
        },
        onTimeRangeInfoTapped: { [weak self] in
            self?.timeRangeInfoButtonTapped()
        },
        onDone: { [weak self] in
            self?.doneButtonTapped()
        }
    ).then {
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.contentView)
    }
    internal let timeInputTransitioner = BottomAnchoredTransitioner()
    internal let preferredContentWidth: CGFloat = 350
    private let layout = BottomAnchoredModalLayout()
    private let viewModel: MutableTimeSettingsViewModel

    // MARK: init
    internal override init() {
        self.viewModel = MutableTimeSettingsViewModel(
            timeSettings: TimeSettingsController.shared.retrieve()
        )

        super.init()
    }
    
    // MARK: setup
    private func setupViews() {
        view.add(fullscreenSubview: contentView)
    }

    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Analytics.record(screen: .timeSettings)
    }

    // MARK: interface actions
    @objc
    private func doneButtonTapped() {
        dismiss(animated: true)
    }

    @objc
    private func timeRangeInfoButtonTapped() {
        let alert = AlertControllers.okAlert(
            withTitle: viewModel.timeRangeInfoAlertTitle(),
            message: viewModel.timeRangeInfoAlertMessage()
        )

        present(alert, animated: true)
    }

    @objc
    private func intervalInfoButtonTapped() {
        let alert = AlertControllers.okAlert(
            withTitle: viewModel.intervalInfoAlertTitle(),
            message: viewModel.intervalInfoAlertMessage()
        )

        present(alert, animated: true)
    }

    private func fromTimeRangeButtonTapped(in view: TimeRangeSelector, timeRange: TimeRange) {
        promptUserForTime(
            from: view,
            initialTime: timeRange.start,
            updateTimeRange: { newTime in
                timeRange.with(start: newTime, validate: true)
            }
        )
    }

    private func toTimeRangeButtonTapped(in view: TimeRangeSelector, timeRange: TimeRange) {
        promptUserForTime(
            from: view,
            initialTime: timeRange.end,
            updateTimeRange: { newTime in
                timeRange.with(end: newTime, validate: true)
            }
        )
    }

    // MARK: prompting
    private func promptUserForTime(
        from view: TimeRangeSelector,
        initialTime: MilitaryTime,
        updateTimeRange: @escaping (MilitaryTime) -> TimeRange
    ) {
        promptUserForTime(
            initialTime: initialTime,
            onDone: { [viewModel] newTime in
                let newTimeRange = updateTimeRange(newTime)

                view.update(timeRange: newTimeRange)

                viewModel.updateTimeSettings(with: newTimeRange)
            }
        )
    }

    // MARK: inset updates
    internal override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11, *) {
            contentView.update(bottomInset: view.safeAreaInsets.bottom)
        }
    }
}
