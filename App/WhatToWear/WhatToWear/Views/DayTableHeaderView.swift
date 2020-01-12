import SnapKit
import Then
import UIKit
import WhatToWearCore
import WhatToWearCoreUI
import WhatToWearModels

internal final class DayTableHeaderView: CodeBackedView, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = DayTableHeaderView

        case dateLabel = "dateLabel"
        case locationLabel = "locationLabel"
        case chart = "chart"
        case whatToWearHeaderView = "whatToWearHeaderView"
    }

    // MARK: layout
    internal enum Layout {
        case portrait
        case landscape
        
        internal var headerContainerPriority: ConstraintPriority {
            switch self {
                case .portrait: return .low
                case .landscape: return .almostRequired
            }
        }
    }

    // MARK: properties
    private let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 27)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.isUserInteractionEnabled = true
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.setContentHuggingPriority(.required, for: .vertical)
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.dateLabel)
    }
    private let locationLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.isUserInteractionEnabled = false
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.setContentHuggingPriority(.required, for: .vertical)
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.locationLabel)
    }
    private lazy var doubleTapGestureRecognizer = UITapGestureRecognizer().then {
        $0.addTarget(self, action: #selector(labelDoubleTapRecognized))
        $0.numberOfTapsRequired = 2
    }
    private let chartContainerView = UIView()
    private let chart: WeatherChartView
    private let whatToWearHeaderContainerView = UIView().then {
        $0.clipsToBounds = true
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.whatToWearHeaderView)
    }
    private let whatToWearHeaderView: WhatToWearHeaderView
    // swiftlint:disable implicitly_unwrapped_optional
    private var whatToWearHeaderZeroHeightConstraint: Constraint!
    // swiftlint:enable implicitly_unwrapped_optional
    private let onLabelDoubleTap: () -> Void

    // MARK: Computed properties
    private var dateLabelFontSize: CGFloat {
        switch InterfaceIdiom.current {
            case .phone: return 27
            case .pad: return 37
        }
    }
    
    private var locationLabelFontSize: CGFloat {
        switch InterfaceIdiom.current {
            case .phone: return 14
            case .pad: return 24
        }
    }
    
    private var locationToChartPadding: CGFloat {
        switch InterfaceIdiom.current {
            case .phone: return 0
            case .pad: return 10
        }
    }
    
    // MARK: init
    internal init(
        chartParams: WeatherChartView.Params,
        layout: Layout,
        headerConfig: WhatToWearHeaderView.Params,
        onLabelDoubleTap: @escaping () -> Void
    ) {
        self.whatToWearHeaderView = WhatToWearHeaderView(config: headerConfig)
        self.chart = WeatherChartView(params: chartParams, context: .mainApp).then {
            $0.accessibilityIdentifier = AccessibilityIdentifiers.chart.rawValue
        }
        self.onLabelDoubleTap = onLabelDoubleTap

        super.init(frame: UIScreen.main.bounds)

        self.dateLabel.text = Self.dateLabelText(
            for: chartParams.day,
            timedForecast: chartParams.forecast
        )
        self.dateLabel.font = .systemFont(ofSize: dateLabelFontSize)
        self.dateLabel.addGestureRecognizer(doubleTapGestureRecognizer)

        self.locationLabel.text = chartParams.location.address
        self.locationLabel.font = .systemFont(ofSize: locationLabelFontSize)

        setupViews()
        transition(toLayout: layout)
    }

    deinit {
        dateLabel.removeGestureRecognizer(doubleTapGestureRecognizer)
    }

    // MARK: init helpers
    private static func dateLabelText(for date: Date, timedForecast: TimedForecast) -> String {
        let timeZone = timedForecast.forecast.timeZone

        if Calendars.shared.calendar(for: timeZone).isDateInToday(date) {
            return NSLocalizedString("Today", comment: "")
        } else {
            return DateFormatters.shared.dayFormatter(for: timeZone).string(from: date)
        }
    }

    // MARK: setup
    private func setupViews() {
        add(subview: dateLabel, withConstraints: { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        })

        add(subview: locationLabel, withConstraints: { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.leading.greaterThanOrEqualToSuperview().offset(10)
            make.trailing.lessThanOrEqualToSuperview().inset(10)
            make.centerX.equalToSuperview()
        })

        add(subview: chart, withConstraints: { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(locationToChartPadding)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(chart.snp.width).multipliedBy(Constants.chartAspectRatio).priority(.high)
        })

        add(
            subview: whatToWearHeaderContainerView,
            withConstraints: { make in
                make.top.equalTo(chart.snp.bottom).offset(10)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
                whatToWearHeaderZeroHeightConstraint = make.height.equalTo(0).priority(.low).constraint
            },
            subviews: { container in
                container.add(subview: whatToWearHeaderView, withConstraints: { make in
                    make.top.equalToSuperview()
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                    make.bottom.equalToSuperview().priority(.high)
                })
            }
        )
    }

    // MARK: transition
    private func transition(toLayout newLayout: Layout) {
        whatToWearHeaderZeroHeightConstraint.update(priority: newLayout.headerContainerPriority)
    }

    // MARK: interface actions
    @objc
    private func labelDoubleTapRecognized() {
        onLabelDoubleTap()
    }
}
