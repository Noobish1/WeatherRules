import SnapKit
import Then
import UIKit
import WhatToWearCoreUI
import WhatToWearModels

internal final class TimeInputContentView: CodeBackedView {
    // MARK: properties
    private let topSeparatorView = SeparatorView()
    private let topContainerView = UIView().then {
        $0.backgroundColor = Colors.blueButton.darker(by: 20.percent)
    }
    private let bottomSeparatorView = SeparatorView()
    private let titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 22)
        $0.textColor = .white
        $0.text = NSLocalizedString("Select Time", comment: "")
    }
    private lazy var timePicker = UIPickerView().then {
        $0.tintColor = .white
        $0.delegate = self
        $0.dataSource = self
    }
    private let leftSeparatorView = SeparatorView()
    private let rightSeparatorView = SeparatorView()
    internal let doneButton = BorderedButton().then {
        $0.titleLabel?.font = .systemFont(ofSize: 14)
        $0.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
    }

    private let viewModel: InputTimeViewModel

    // MARK: init
    internal init(time: MilitaryTime) {
        self.viewModel = InputTimeViewModel(time: time)

        super.init(frame: .zero)

        setupViews()
        setupDatePicker(with: time)
    }

    // MARK: setup
    private func setupViews() {
        topContainerView.add(topSeparatorView: topSeparatorView)

        topContainerView.add(subview: titleLabel, withConstraints: { make in
            make.top.equalTo(topSeparatorView.snp.bottom)
            make.centerX.equalToSuperview()
        })

        topContainerView.add(subview: doneButton, withConstraints: { make in
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.height.equalTo(36)
            make.top.lessThanOrEqualToSuperview().inset(8)
            make.bottom.lessThanOrEqualToSuperview().inset(8)
            make.width.equalTo(60)
        })

        topContainerView.add(subview: bottomSeparatorView, withConstraints: { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        })

        add(subview: topContainerView, withConstraints: { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        })

        add(subview: timePicker, withConstraints: { make in
            make.top.equalTo(topContainerView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        })

        if #available(iOS 11, *) {
            add(leftSeparatorView: leftSeparatorView)
            add(rightSeparatorView: rightSeparatorView)
        }
    }

    private func setupDatePicker(with time: MilitaryTime) {
        timePicker.selectRow(viewModel.initialRow, inComponent: 0, animated: false)
    }

    // MARK: styling
    internal func styleTimePicker() {
        // Have to do this like this for some reason
        DispatchQueue.main.asyncAfter(deadline: 0.1.fromNow) {
            self.timePicker.setSeparatorColor(.white)
        }
    }

    // MARK: getting time
    internal func timePickerTime() -> MilitaryTime {
        let row = timePicker.selectedRow(inComponent: 0)

        return viewModel.viewModel(forRow: row).time
    }
}

// MARK: UIPickerViewDataSource
extension TimeInputContentView: UIPickerViewDataSource {
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numberOfRows
    }
}

// MARK: UIPickerViewDelegate
extension TimeInputContentView: UIPickerViewDelegate {
    internal func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(
            string: viewModel.viewModel(forRow: row).displayedString,
            attributes: [.foregroundColor: UIColor.white]
        )
    }
}
