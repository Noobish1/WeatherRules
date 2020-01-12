import ErrorRecorder
import NotificationCenter
import SnapKit
import Then
import UIKit
import WhatToWearCore
import WhatToWearCoreUI
import WhatToWearExtensionCore
import WhatToWearModels

// MARK: TodayViewController
internal final class TodayViewController: CodeBackedViewController, ForecastDisplayerViewControllerProtocol, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = TodayViewController

        case locationLabel = "locationLabel"
        case chart = "chart"
    }

    // MARK: properties
    private let chartAspectRatio = ExtensionConstants.chartAspectRatio
    private lazy var locationLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.isUserInteractionEnabled = false
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.setContentHuggingPriority(.required, for: .vertical)
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.locationLabel)
        $0.text = initialParams.location.address
    }
    private let chart: WeatherChartView
    
    internal let initialParams: ForecastLoadingParams

    // MARK: init
    internal init(params: ForecastLoadingParams) {
        self.chart = WeatherChartView(params: .init(params: params), context: .todayExtension).then {
            $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.chart)
        }
        self.initialParams = params
        
        super.init()
    }

    // MARK: setup
    private func setupViews() {
        let topAndBottomPadding = ExtensionConstants.forecastTopAndBottomPadding

        self.view.add(subview: locationLabel, withConstraints: { make in
            make.top.equalToSuperview().offset(topAndBottomPadding)
            make.leading.greaterThanOrEqualToSuperview().offset(10)
            make.trailing.lessThanOrEqualToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(ExtensionConstants.forecastLocationLabelHeight)
        })

        self.view.add(subview: chart, withConstraints: { make in
            make.top.equalTo(locationLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(chart.snp.width).multipliedBy(chartAspectRatio)
            make.bottom.equalToSuperview().inset(topAndBottomPadding)
        })
    }

    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        onAppear()
    }
}
