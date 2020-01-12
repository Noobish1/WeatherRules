import RxSwift
import Then
import UIKit
import WhatToWearCore
import WhatToWearCoreUI
import WhatToWearModels

internal final class TimeRangeSelector: CodeBackedView {
    // MARK: properties
    private lazy var fromButton = InsetButton(
        color: Colors.blueButton.darker(by: 10.percent),
        insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10),
        onTap: { [weak self] in
            guard let strongSelf = self else { return }

            strongSelf.onFromTap(strongSelf, strongSelf.viewModel.timeRange)
        }
    ).then {
        $0.label.textColor = .white
    }
    private let fromLine = UIView().then {
        $0.backgroundColor = .white
    }
    private let horizontalLine = UIView().then {
        $0.backgroundColor = .white
    }
    private let toLine = UIView().then {
        $0.backgroundColor = .white
    }
    private lazy var toButton = InsetButton(
        color: Colors.blueButton.darker(by: 10.percent),
        insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10),
        onTap: { [weak self] in
            guard let strongSelf = self else { return }

            strongSelf.onToTap(strongSelf, strongSelf.viewModel.timeRange)
        }
    ).then {
        $0.label.textColor = .white
    }
    private let onFromTap: (TimeRangeSelector, TimeRange) -> Void
    private let onToTap: (TimeRangeSelector, TimeRange) -> Void
    private let viewModel: MutableTimeRangeViewModel
    private let disposeBag = DisposeBag()

    // MARK: init
    internal init(
        timeRange: TimeRange,
        onFromTap: @escaping (TimeRangeSelector, TimeRange) -> Void,
        onToTap: @escaping (TimeRangeSelector, TimeRange) -> Void
    ) {
        // We don't care about timezones here,
        // The user selects a time range disregarding timezones
        self.viewModel = MutableTimeRangeViewModel(timeRange: timeRange, timeZone: .current)
        self.onFromTap = onFromTap
        self.onToTap = onToTap

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
            make.height.equalTo(44)
        })

        add(subview: fromLine, withConstraints: { make in
            make.top.equalToSuperview()
            make.leading.equalTo(fromButton.snp.trailing).offset(10)
            make.bottom.equalToSuperview()
            make.width.equalTo(1)
        })

        add(subview: horizontalLine, withConstraints: { make in
            make.leading.equalTo(fromLine.snp.trailing)
            make.centerY.equalToSuperview()
            make.height.equalTo(1)
        })

        add(subview: toLine, withConstraints: { make in
            make.top.equalToSuperview()
            make.leading.equalTo(horizontalLine.snp.trailing)
            make.bottom.equalToSuperview()
            make.width.equalTo(1)
        })

        add(subview: toButton, withConstraints: { make in
            make.top.equalToSuperview()
            make.leading.equalTo(toLine.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(fromButton)
        })
    }
    
    private func setupObservers() {
        viewModel.fromDriver.drive(fromButton.label.rx.text).disposed(by: disposeBag)
        viewModel.toDriver.drive(toButton.label.rx.text).disposed(by: disposeBag)
    }

    // MARK: update
    internal func update(timeRange: TimeRange) {
        viewModel.update(with: timeRange)
    }
}
