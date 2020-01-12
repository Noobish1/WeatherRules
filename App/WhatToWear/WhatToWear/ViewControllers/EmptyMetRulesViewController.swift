import ErrorRecorder
import SnapKit
import Then
import UIKit
import WhatToWearCoreComponents
import WhatToWearCoreUI
import WhatToWearModels

internal final class EmptyMetRulesViewController: CodeBackedViewController, MetRulesViewControllerProtocol, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = EmptyMetRulesViewController

        case mainView = "mainView"
        case portraitHeaderView = "portraitHeaderView"
        case landscapeHeaderView = "landscapeHeaderView"
        case whatToWearHeaderView = "whatToWearHeaderView"
        case label = "label"
    }

    // MARK: properties
    internal lazy var portraitHeaderView = self.makeHeaderView(forLayout: .portrait).then {
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.portraitHeaderView)
    }
    internal lazy var landscapeHeaderView = self.makeHeaderView(forLayout: .landscape).then {
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.landscapeHeaderView)
    }
    internal lazy var whatToWearHeaderView = self.makeWhatToWearHeaderView().then {
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.whatToWearHeaderView)
    }
    private lazy var label = UILabel().then {
        $0.textColor = .white
        $0.text = labelText
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.label)
    }
    internal let landscapeHeaderContainerView = UIView()
    internal let landscapeHorizontalSeparatorView = SeparatorView()
    internal let landscapeLeftContainerView = UIView()
    
    internal let chartParams: WeatherChartView.Params
    internal let settings: GlobalSettings
    internal let onLabelDoubleTap: () -> Void
    internal lazy var layout = MetRulesLayout(viewSize: self.view.frame.size)
    private let labelText: String

    // MARK: status bar
    internal override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: init/deinit
    internal init(
        chartParams: WeatherChartView.Params,
        settings: GlobalSettings,
        labelText: String,
        onLabelDoubleTap: @escaping () -> Void
    ) {
        self.chartParams = chartParams
        self.settings = settings
        self.labelText = labelText
        self.onLabelDoubleTap = onLabelDoubleTap

        super.init()
    }

    // MARK: setup
    internal func setupViews(for layout: MetRulesLayout) {
        switch layout {
            case .portrait:
                view.add(subview: portraitHeaderView, withConstraints: { make in
                    make.top.equalToSuperview()
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                })

                view.add(subview: label, withConstraints: { make in
                    make.top.equalTo(portraitHeaderView.snp.bottom).offset(20)
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                    make.bottom.lessThanOrEqualToSuperview()
                })
            case .landscape:
                layoutLandscapeViews(leftContainerViewSubviews: { container in
                    container.add(subview: whatToWearHeaderView, withConstraints: { make in
                        make.top.equalToSuperview()
                        make.leading.equalToSuperview()
                        make.trailing.equalToSuperview()
                    })
                    
                    container.add(subview: label, withConstraints: { make in
                        make.top.equalTo(whatToWearHeaderView.snp.bottom)
                        make.leading.equalToSuperview().offset(10)
                        make.trailing.equalToSuperview().inset(10)
                        make.bottom.equalToSuperview()
                    })
                })
        }
    }

    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()

        view.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.mainView)

        setupViews(for: layout)
    }

    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Analytics.record(screen: .emptyMetRules)
    }

    // MARK: rotation
    internal override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)

        let layout = MetRulesLayout(viewSize: size)

        coordinator.animate(alongsideTransition: { _ in
            self.transition(toLayout: layout)
        })
    }
}
