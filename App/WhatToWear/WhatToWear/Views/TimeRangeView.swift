import RxSwift
import UIKit
import WhatToWearCore
import WhatToWearCoreUI
import WhatToWearModels

internal final class TimeRangeView: CodeBackedView {
    // MARK: private properties
    private let fromButton = UIButton(type: .system).then {
        $0.setTitleColor(.yellow, for: .normal)
        $0.addTarget(self, action: #selector(fromButtonTapped), for: .touchUpInside)
    }
    private let andLabel = UILabel().then {
        $0.textColor = .white
        $0.text = NSLocalizedString("and", comment: "")
    }
    private let untilButton = UIButton(type: .system).then {
        $0.setTitleColor(.yellow, for: .normal)
        $0.addTarget(self, action: #selector(untilButtonTapped), for: .touchUpInside)
    }
    private let onFromTap: (TimeRangeView, TimeRange) -> Void
    private let onUntilTap: (TimeRangeView, TimeRange) -> Void
    private let viewModel: MutableTimeRangeViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: init/deinit
    internal init(
        timeRange: TimeRange,
        onFromTap: @escaping (TimeRangeView, TimeRange) -> Void,
        onUntilTap: @escaping (TimeRangeView, TimeRange) -> Void
    ) {
        // We don't care about timezones here as the user selections time ranges disregarding timezones
        self.viewModel = MutableTimeRangeViewModel(timeRange: timeRange, timeZone: .current)
        self.onFromTap = onFromTap
        self.onUntilTap = onUntilTap

        super.init(frame: .zero)

        setupViews()
        setupObservers()
    }

    // MARK: setup
    private func setupViews() {
        add(subview: fromButton, withConstraints: { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        })

        add(subview: andLabel, withConstraints: { make in
            make.top.equalToSuperview()
            make.leading.equalTo(fromButton.snp.trailing).offset(4)
            make.bottom.equalToSuperview()
        })

        add(subview: untilButton, withConstraints: { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalTo(andLabel.snp.trailing).offset(4)
            make.trailing.equalToSuperview()
            make.width.equalTo(fromButton.snp.width)
        })
    }
    
    private func setupObservers() {
        viewModel.fromDriver.drive(fromButton.rx.title()).disposed(by: disposeBag)
        viewModel.toDriver.drive(untilButton.rx.title()).disposed(by: disposeBag)
    }

    // MARK: interface actions
    @objc
    private func fromButtonTapped() {
        onFromTap(self, viewModel.timeRange)
    }

    @objc
    private func untilButtonTapped() {
        onUntilTap(self, viewModel.timeRange)
    }
}
