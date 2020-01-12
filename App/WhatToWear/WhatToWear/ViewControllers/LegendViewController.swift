import CoreLocation
import ErrorRecorder
import Then
import WhatToWearCore
import WhatToWearCoreUI
import WhatToWearModels

// MARK: LegendViewController
internal final class LegendViewController: CodeBackedViewController, NavStackEmbedded {
    // MARK: Layout
    internal enum Layout: Equatable {
        // MARK: Orientation
        internal enum Orientation {
            case portrait
            case landscape
        }
        
        // MARK: cases
        case pad
        case phone(Orientation)

        // MARK: init
        internal init(viewSize: CGSize) {
            switch InterfaceIdiom.current {
                case .pad:
                    self = .pad
                case .phone:
                    if viewSize.width > viewSize.height {
                        self = .phone(.landscape)
                    } else {
                        self = .phone(.portrait)
                    }
            }
        }
    }

    // MARK: properties
    private let backgroundView = BasicBackgroundView()
    private let navBarSeparatorView = SeparatorView()
    private let containerView = UIView()
    private let portraitHeaderView: LegendHeaderView
    private let landscapeChartView: WeatherChartView
    private let landscapeHeaderView: LandscapeLegendHeaderView
    private let cellReuseIdentifier = "legendCell"
    private lazy var tableView = UITableView(frame: UIScreen.main.bounds).then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 44
        $0.rowHeight = UITableView.automaticDimension
        $0.dataSource = self
        $0.delegate = self
        $0.register(LegendTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    private lazy var layout = Layout(viewSize: self.view.frame.size)
    private let viewModel: LegendViewModel
    private let chartParams: WeatherChartView.Params
    private let settings: GlobalSettings
    
    // MARK: status bar
    internal override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: init
    internal init(settings: GlobalSettings) {
        self.viewModel = LegendViewModel(settings: settings)
        
        let fudgedParams = WeatherChartView.Params.legendParams(settings: settings)

        self.chartParams = fudgedParams
        self.settings = settings

        let title = NSLocalizedString("Components of a Forecast", comment: "")

        let titleInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        
        self.portraitHeaderView = LegendHeaderView(
            chartParams: fudgedParams.with(\.componentsToShow, value: Set(WeatherChartComponent.allCases)),
            title: title,
            bottomSeparatorHidden: false,
            titleInsets: titleInsets
        )
        self.landscapeChartView = WeatherChartView(
            params: fudgedParams.with(\.componentsToShow, value: Set(WeatherChartComponent.allCases)),
            context: .legend
        )
        self.landscapeHeaderView = LandscapeLegendHeaderView(title: title, titleInsets: titleInsets)

        super.init()

        self.title = NSLocalizedString("Legend", comment: "")
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
    
    private func setupTableViewAndHeaderView(for layout: Layout) {
        switch layout {
            case .pad, .phone(.portrait):
                tableView.tableHeaderView = portraitHeaderView

                containerView.add(subview: tableView, withConstraints: { make in
                    make.top.equalTo(navBarSeparatorView.snp.bottom)
                    make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
                    make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
                    make.bottom.equalToSuperviewOrSafeAreaLayoutGuide()
                })
            case .phone(.landscape):
                tableView.tableHeaderView = nil

                containerView.add(subview: landscapeChartView, withConstraints: { make in
                    make.centerY.equalToSuperviewOrSafeAreaLayoutGuide()
                    make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
                    make.height.equalTo(landscapeChartView.snp.width)
                        .multipliedBy(Constants.chartAspectRatio)
                })

                containerView.add(subview: landscapeHeaderView, withConstraints: { make in
                    make.top.equalTo(navBarSeparatorView.snp.bottom).offset(10)
                    make.leading.equalTo(landscapeChartView.snp.trailing)
                    make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
                    make.width.equalTo(landscapeChartView)
                })

                containerView.add(subview: tableView, withConstraints: { make in
                    make.top.equalTo(landscapeHeaderView.snp.bottom)
                    make.leading.equalTo(landscapeChartView.snp.trailing)
                    make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
                    make.width.equalTo(landscapeChartView)
                    make.bottom.equalToSuperviewOrSafeAreaLayoutGuide()
                })
        }
    }

    private func setupViews() {
        view.add(fullscreenSubview: backgroundView)

        view.add(topSeparatorView: navBarSeparatorView, beneath: self.topLayoutGuide.snp.bottom)

        view.add(subview: containerView, withConstraints: { make in
            make.top.equalTo(navBarSeparatorView.snp.bottom)
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
            make.bottom.equalToSuperviewOrSafeAreaLayoutGuide()
        })

        setupTableViewAndHeaderView(for: layout)

        tableView.layoutHeaderAndFooterViews()
    }

    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupViews()
        setupBarButtonItemsIfNeeded()
    }

    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navController.setNavigationBarHidden(false, animated: animated)
        
        transitionCoordinator?.animate(alongsideTransition: { _ in
            self.deselectAllRowsIfNeeded(animated: animated)
        })
    }

    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Analytics.record(screen: .legend)
        
        deselectAllRowsIfNeeded(animated: false)
    }

    // MARK: deselection
    private func deselectAllRowsIfNeeded(animated: Bool) {
        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: animated)
        }
    }
    
    // MARK: interface actions
    @objc
    private func doneButtonTapped() {
        dismiss(animated: true)
    }
    
    // MARK: transition
    internal func transition(toLayout newLayout: Layout, force: Bool = false) {
        guard force || newLayout != self.layout else { return }

        containerView.subviews.forEach { $0.removeFromSuperview() }

        setupTableViewAndHeaderView(for: newLayout)

        // We have to delay this by a runloop
        // otherwise the chart ends up being squished vertically
        DispatchQueue.main.async {
            self.tableView.layoutHeaderAndFooterViews()
        }

        self.layout = newLayout
    }
    
    // MARK: rotation
    internal override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        let layout = Layout(viewSize: size)

        coordinator.animate(alongsideTransition: { _ in
            self.transition(toLayout: layout)
        })
    }
}

// MARK: UITableViewDataSource
extension LegendViewController: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfComponents
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let componentViewModel = viewModel.componentViewModel(at: indexPath)

        let cell: LegendTableViewCell = tableView.wtw_dequeueReusableCell(
            identifier: cellReuseIdentifier, indexPath: indexPath
        )
        cell.configure(with: componentViewModel)

        return cell
    }
}

// MARK: UITableViewDelegate
extension LegendViewController: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = LegendComponentViewController(
            chartParams: chartParams,
            component: viewModel.rawComponent(at: indexPath),
            settings: settings
        )

        navController.pushViewController(vc, animated: true)
    }
}
