import UIKit
import WhatToWearCore
import WhatToWearCoreUI
import WhatToWearModels

internal final class TimeSettingsContentView: CodeBackedView, Accessible {
    // MARK: SubtitleLabel
    private final class SubtitleLabel: UILabel {
        fileprivate convenience init(text: String, identifier: AccessibilityIdentifiers) {
            self.init()

            self.text = text
            self.textColor = .white
            self.font = .systemFont(ofSize: 16, weight: .semibold)
            self.wtw_setAccessibilityIdentifier(identifier)
        }
    }

    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = TimeSettingsContentView

        case titleLabel = "titleLabel"
        case timeRangeTitle = "timeRangeTitle"
        case timeRangeSelector = "timeRangeSelector"
        case intervalTitle = "intervalTitle"
        case intervalSegmentedControl = "intervalSegmentedControl"
        case doneButton = "doneButton"
    }

    // MARK: properties
    private let titleTopSeparator = SeparatorView()
    private let titleLabel = UILabel().then {
        $0.text = NSLocalizedString("Time Settings", comment: "")
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.titleLabel)
        $0.setContentHuggingPriority(.required, for: .vertical)
    }
    private let titleBottomSeparator = SeparatorView()
    private let timeRangeTitle = SubtitleLabel(
        text: NSLocalizedString("Time Range", comment: ""),
        identifier: .timeRangeTitle
    ).then {
        $0.setContentHuggingPriority(.required, for: .vertical)
    }
    private let timeRangeInfoButton = InfoButton().then {
        $0.addTarget(
            self,
            action: #selector(timeRangeInfoButtonTapped),
            for: .touchUpInside
        )
    }
    private let timeRangeSelector: TimeRangeSelector
    private let intervalTitle = SubtitleLabel(
        text: NSLocalizedString("Intervals", comment: ""),
        identifier: .intervalTitle
    ).then {
        $0.setContentHuggingPriority(.required, for: .vertical)
    }
    private let intervalInfoButton = InfoButton().then {
        $0.addTarget(
            self,
            action: #selector(intervalInfoButtonTapped),
            for: .touchUpInside
        )
    }
    private let intervalSegmentedControl: SegmentedControl<TimeSettingsIntervalViewModel>
    private lazy var doneButton = BottomAnchoredButton(
        bottomInset: self.wtw_bottomSafeInset,
        onTap: self.onDone
    ).then {
        $0.update(title: NSLocalizedString("Done", comment: ""))
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.doneButton)
    }
    private let onIntervalInfoTapped: () -> Void
    private let onTimeRangeInfoTapped: () -> Void
    private let onDone: () -> Void

    // MARK: init
    internal init(
        timeSettings: TimeSettings,
        onFromTap: @escaping (TimeRangeSelector, TimeRange) -> Void,
        onToTap: @escaping (TimeRangeSelector, TimeRange) -> Void,
        onIntervalChange: @escaping (TimeSettings.Interval) -> Void,
        onIntervalInfoTapped: @escaping () -> Void,
        onTimeRangeInfoTapped: @escaping () -> Void,
        onDone: @escaping () -> Void
    ) {
        self.intervalSegmentedControl = SegmentedControl(
            initialValue: TimeSettingsIntervalViewModel(model: timeSettings.interval),
            onSegmentChange: {
                onIntervalChange($0.underlyingModel)
            }
        ).then {
            $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.intervalSegmentedControl)
        }
        self.timeRangeSelector = TimeRangeSelector(
            timeRange: timeSettings.timeRange,
            onFromTap: onFromTap,
            onToTap: onToTap
        ).then {
            $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.timeRangeSelector)
        }
        self.onIntervalInfoTapped = onIntervalInfoTapped
        self.onTimeRangeInfoTapped = onTimeRangeInfoTapped
        self.onDone = onDone

        super.init(frame: .zero)

        setupViews()
    }

    // MARK: setup
    private func setupViews() {
        add(topSeparatorView: titleTopSeparator)
        
        add(subview: titleLabel, withConstraints: { make in
            make.top.equalTo(titleTopSeparator.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
        })
        
        add(topSeparatorView: titleBottomSeparator, beneath: titleLabel, offset: 10)
        
        setupSection(below: titleBottomSeparator, title: timeRangeTitle, infoButton: timeRangeInfoButton, control: timeRangeSelector)
        
        setupSection(below: timeRangeSelector, title: intervalTitle, infoButton: intervalInfoButton, control: intervalSegmentedControl)
        
        switch InterfaceIdiom.current {
            case .phone:
                add(subview: doneButton, withConstraints: { make in
                    make.top.equalTo(intervalSegmentedControl.snp.bottom).offset(40)
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                    make.bottom.equalToSuperview()
                })
            case .pad:
                intervalSegmentedControl.snp.makeConstraints { make in
                    make.bottom.equalToSuperview().inset(20)
                }
        }
    }
    
    private func setupSection(below aboveView: UIView, title: UILabel, infoButton: InfoButton, control: UIView) {
        add(subview: title, withConstraints: { make in
            make.top.equalTo(aboveView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
        })
        
        add(subview: infoButton, withConstraints: { make in
            make.centerY.equalTo(title)
            make.leading.greaterThanOrEqualTo(title.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
        })
        
        add(subview: control, withConstraints: { make in
            make.top.equalTo(title.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
        })
    }

    // MARK: update
    internal func update(bottomInset: CGFloat) {
        doneButton.update(bottomInset: bottomInset)
    }
    
    // MARK: interface actions
    @objc
    private func timeRangeInfoButtonTapped() {
        onTimeRangeInfoTapped()
    }
    
    @objc
    private func intervalInfoButtonTapped() {
        onIntervalInfoTapped()
    }
}
