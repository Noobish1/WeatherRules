import SnapKit
import Then
import UIKit
import WhatToWearAssets
import WhatToWearCoreUI
import WhatToWearModels

internal final class ToolbarView: CodeBackedView, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = ToolbarView

        case editLocationButton = "editLocationButton"
        case settingsButton = "settingsButton"
        case timeSettingsButton = "timeSettingsButton"
    }

    // MARK: properties
    private let separatorView = SeparatorView().then {
        ShadowConfigurator.configureTopShadow(for: $0)
    }
    private let warningView = UIImageView(image: R.image.warningIcon()).then {
        $0.tintColor = .white
        $0.isHidden = true
    }
    internal let timeSettingsButton: TimeSettingsButton
    internal let editLocationButton = UIButton(type: .system).then {
        $0.tintColor = .white
        $0.setImage(R.image.editLocationButton(), for: .normal)
        $0.setTitle("", for: .normal)
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.editLocationButton)
    }
    internal let settingsButton = UIButton(type: .system).then {
        $0.tintColor = .white
        $0.setImage(R.image.settingsButton(), for: .normal)
        $0.setTitle("", for: .normal)
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.settingsButton)
    }

    // MARK: init
    internal init(
        timeSettings: TimeSettings,
        timedForecast: TimedForecast,
        globalSettings: GlobalSettings
    ) {
        self.timeSettingsButton = TimeSettingsButton(
            timeSettings: timeSettings,
            timedForecast: timedForecast
        ).then {
            $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.timeSettingsButton)
        }

        super.init(frame: .zero)

        self.clipsToBounds = false

        setupViews()

        update(globalSettings: globalSettings)
    }

    // MARK: setup
    private func setupViews() {
        add(topSeparatorView: separatorView)

        add(subview: editLocationButton, withConstraints: { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(10)
            make.size.equalTo(44)
        })

        add(subview: timeSettingsButton, withConstraints: { make in
            make.top.equalToSuperview().offset(10)
            make.leading.greaterThanOrEqualTo(editLocationButton.snp.trailing)
            make.bottom.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        })

        add(subview: settingsButton, withConstraints: { make in
            make.leading.greaterThanOrEqualTo(timeSettingsButton.snp.trailing)
            make.trailing.equalToSuperview().inset(14)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(10)
            make.size.equalTo(44)
        })

        add(subview: warningView, withConstraints: { make in
            make.centerX.equalTo(settingsButton.snp.trailing).inset(8)
            make.centerY.equalTo(settingsButton.snp.top).inset(8)
            make.size.equalTo(22)
        })
    }

    // MARK: update
    internal func update(globalSettings: GlobalSettings) {
        warningView.isHidden = globalSettings.updateWarningState == .hide
    }

    internal func update(timeSettings: TimeSettings) {
        timeSettingsButton.update(timeSettings: timeSettings)
    }
}
