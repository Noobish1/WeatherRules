import UIKit
import WhatToWearCore
import WhatToWearCoreUI
import WhatToWearModels

internal final class TimeSettingsButton: CodeBackedButton {
    // MARK: PhoneSize
    internal enum PhoneSize {
        case small
        case large

        // MARK: init
        internal init() {
            if UIScreen.main.bounds.width > 320 {
                self = .large
            } else {
                self = .small
            }
        }

        // MARK: computed properties
        fileprivate var titleLabelFont: UIFont {
            switch self {
                case .small: return .systemFont(ofSize: 15, weight: .regular)
                case .large: return .systemFont(ofSize: 17, weight: .regular)
            }
        }
    }

    // MARK: properties
    private let phoneSize = PhoneSize()
    private let titleColor = UIColor.white
    private let timedForecast: TimedForecast

    // MARK: overrides
    internal override var isHighlighted: Bool {
        didSet {
            setTitleColor(
                isHighlighted ? titleColor.darker(by: 30.percent) : titleColor, for: .normal
            )
        }
    }

    // MARK: init
    internal init(timeSettings: TimeSettings, timedForecast: TimedForecast) {
        self.timedForecast = timedForecast

        super.init(frame: .zero)

        self.tintColor = .white
        self.titleLabel?.font = phoneSize.titleLabelFont

        update(timeSettings: timeSettings)
    }

    // MARK: update
    internal func update(timeSettings: TimeSettings) {
        let timeZone = timedForecast.forecast.timeZone
        let title = TimeSettingsViewModel.title(for: timeSettings, timeZone: timeZone)

        self.setTitle(title, for: .normal)
    }
}
