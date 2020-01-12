import ErrorRecorder
import UIKit
import WhatToWearCoreUI
import WhatToWearModels

internal final class LegendComponentViewController: CodeBackedViewController, NavStackEmbedded {
    // MARK: Layout
    internal enum Layout: Equatable {
        // MARK: PhoneSize
        internal enum PhoneSize {
            case small
            case large

            // MARK: init
            internal init(width: CGFloat) {
                self = width > 320 ? .large : .small
            }

            // MARK: computed properties
            internal var landscapeChartTopOffset: CGFloat {
                switch self {
                    case .small: return 16
                    case .large: return 0
                }
            }
        }

        internal enum Orientaton {
            case portrait
            case landscape
        }
        
        case pad
        case phone(orientation: Orientaton, size: PhoneSize)

        // MARK: init
        internal init(viewSize: CGSize) {
            switch InterfaceIdiom.current {
                case .pad:
                    self = .pad
                case .phone:
                    if viewSize.width > viewSize.height {
                        self = .phone(orientation: .landscape, size: .init(width: viewSize.height))
                    } else {
                        self = .phone(orientation: .portrait, size: .init(width: viewSize.width))
                    }
            }
        }

        // MARK: computed properties
        internal var descriptionFont: UIFont {
            switch self {
                case .pad:
                    return .systemFont(ofSize: 16, weight: .regular)
                case .phone(orientation: let orientation, size: let size):
                    switch (orientation, size) {
                        case (.landscape, .small), (.portrait, .small):
                            return .systemFont(ofSize: 14, weight: .regular)
                        case (.landscape, .large), (.portrait, .large):
                            return .systemFont(ofSize: 16, weight: .regular)
                    }
            }
        }
        
        internal var chartAspectRatio: CGFloat {
            switch self {
                case .pad: return 260 / 540
                case .phone: return Constants.chartAspectRatio
            }
        }
    }

    // MARK: properties
    private let backgroundView = BasicBackgroundView()
    private lazy var contentView = LegendComponentContentView(
        chartParams: chartParams,
        component: component,
        viewModel: viewModel,
        layout: layout
    )
    private let viewModel: LegendComponentViewModel
    private lazy var layout = Layout(viewSize: self.view.frame.size)
    private let chartParams: WeatherChartView.Params
    private let component: WeatherChartComponent
    
    // MARK: init
    internal init(
        chartParams: WeatherChartView.Params,
        component: WeatherChartComponent,
        settings: GlobalSettings
    ) {
        self.chartParams = chartParams
        self.component = component
        self.viewModel = LegendComponentViewModel(component: component, settings: settings)

        super.init()

        self.title = viewModel.title
    }

    // MARK: setup
    private func setupBarButtonItemsIfNeeded() {
        guard case .pad = InterfaceIdiom.current else {
            return
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped)
        )
    }

    private func setupViews() {
        view.add(fullscreenSubview: backgroundView)

        view.add(subview: contentView, withConstraints: { make in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
            make.bottom.equalToSuperviewOrSafeAreaLayoutGuide()
        })
    }

    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupViews()
        setupBarButtonItemsIfNeeded()
    }

    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Analytics.record(screen: .legendComponent(viewModel.analyticsValue))
    }

    // MARK: interface actions
    @objc
    private func doneButtonTapped() {
        dismiss(animated: true)
    }
    
    // MARK: transition
    internal func transition(toLayout newLayout: Layout, force: Bool = false) {
        guard force || newLayout != self.layout else { return }

        contentView.update(layout: newLayout)

        self.layout = newLayout
    }

    // MARK: rotation
    internal override func viewWillTransition(
        to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)

        let layout = Layout(viewSize: size)

        coordinator.animate(alongsideTransition: { _ in
            self.transition(toLayout: layout)
        })
    }
}
