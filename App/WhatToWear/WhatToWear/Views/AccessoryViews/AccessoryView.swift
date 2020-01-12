import SnapKit
import Then
import UIKit
import WhatToWearCore
import WhatToWearCoreUI

internal class AccessoryView: CodeBackedView, UITextFieldDelegate, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = AccessoryView

        case titleLabel = "titleLabel"
        case doneButton = "doneButton"
        case textField = "textField"
    }

    // MARK: properties
    private let topSeparatorView = SeparatorView().then {
        ShadowConfigurator.configureTopShadow(for: $0)
    }
    private lazy var titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .white
        $0.font = .boldSystemFont(ofSize: 20)
        $0.text = title
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.titleLabel)
    }
    private let titleLabelBottomSeparatorView = SeparatorView()
    private lazy var doneButton = BorderedButton().then {
        $0.titleLabel?.font = .systemFont(ofSize: 13)
        $0.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
        $0.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.doneButton)
    }
    internal lazy var textField = UITextField().then {
        $0.backgroundColor = .clear
        $0.textAlignment = .center
        $0.tintColor = .white
        $0.textColor = .white
        $0.delegate = self
        $0.text = initialValue
        $0.backgroundColor = Colors.blueButton.darker(by: 20.percent)
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.textField)
    }
    private let leftSeparatorView = SeparatorView()
    private let rightSeparatorView = SeparatorView()
    private let backgroundView = UIView().then {
        $0.backgroundColor = Colors.blueButton
    }

    private let initialValue: String?
    private let title: String

    // MARK: init/deinit
    internal init(title: String, value: String?) {
        self.title = title
        self.initialValue = value

        super.init(frame: CGRect(origin: .zero, size: CGSize(width: 320, height: 88)))

        setupViews()
    }

    // MARK: setup
    private func setupViews() {
        backgroundColor = .clear

        add(subview: backgroundView, withConstraints: { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
            make.bottom.equalToSuperview()
        })

        add(topSeparatorView: topSeparatorView)

        add(subview: titleLabel, withConstraints: { make in
            make.top.equalTo(topSeparatorView.snp.bottom)
            make.centerX.equalToSuperview()
        })

        add(topSeparatorView: titleLabelBottomSeparatorView, beneath: titleLabel)

        add(subview: doneButton, withConstraints: { make in
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide().inset(8)
            make.top.equalTo(topSeparatorView.snp.bottom).offset(4)
            make.width.equalTo(60)
            make.height.equalTo(34)
        })

        add(subview: textField, withConstraints: { make in
            make.top.equalTo(titleLabelBottomSeparatorView.snp.bottom)
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
        })

        if #available(iOS 11, *) {
            clipsToBounds = true

            add(leftSeparatorView: leftSeparatorView, onTheRightOf: self.safeAreaLayoutGuide)
            add(rightSeparatorView: rightSeparatorView, onTheLeftOf: self.safeAreaLayoutGuide)
        }
    }

    // MARK: interface actions
    @objc
    internal func doneButtonTapped() {
        textField.resignFirstResponder()
    }

    // MARK: UIResponder
    internal override func becomeFirstResponder() -> Bool {
        return self.textField.becomeFirstResponder()
    }

    // MARK: UITextFieldDelegate
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        doneButtonTapped()

        return false
    }
}
