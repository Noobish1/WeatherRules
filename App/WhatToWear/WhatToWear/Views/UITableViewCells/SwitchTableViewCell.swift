import UIKit
import WhatToWearCoreUI

internal final class SwitchTableViewCell: CodeBackedCell {
    // MARK: properties
    private let label = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
    }
    private lazy var ourSwitch = UISwitch().then {
        $0.tintColor = Colors.blueButton.darker(by: 10.percent)
        $0.onTintColor = Colors.blueButton
        
        $0.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }
    private let separatorView = SeparatorView()
    private var onValueChanged: ((Bool) -> Void)?
    
    // MARK: setup
    internal override func setupViews() {
        super.setupViews()
        
        backgroundColor = .clear
        
        contentView.add(subview: label, withConstraints: { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview().offset(20)
            make.bottom.lessThanOrEqualToSuperview().inset(20)
        })
        
        contentView.add(subview: ourSwitch, withConstraints: { make in
            make.leading.equalTo(label.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        })
        
        add(subview: separatorView, withConstraints: { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().priority(.almostRequired)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        })
    }
    
    // MARK: reuse
    internal override func prepareForReuse() {
        super.prepareForReuse()
        
        onValueChanged = nil
    }
    
    // MARK: interface actions
    @objc
    private func valueChanged() {
        onValueChanged?(ourSwitch.isOn)
    }
    
    // MARK: configuration
    internal func configure(withTitle title: String, isOn: Bool, onValueChanged: @escaping (Bool) -> Void) {
        label.text = title
        ourSwitch.isOn = isOn
        self.onValueChanged = onValueChanged
    }
}
