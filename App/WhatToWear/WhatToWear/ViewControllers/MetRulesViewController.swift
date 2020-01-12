import ErrorRecorder
import SnapKit
import Then
import UIKit
import WhatToWearCommonCore
import WhatToWearCore
import WhatToWearCoreComponents
import WhatToWearCoreUI
import WhatToWearModels

internal final class MetRulesViewController: CodeBackedViewController, MetRulesViewControllerProtocol {
    // MARK: properties
    private let reuseIdentifier = "ruleSectionCell"
    internal lazy var portraitHeaderView = self.makeHeaderView(forLayout: .portrait)
    internal lazy var landscapeHeaderView = self.makeHeaderView(forLayout: .landscape)
    internal lazy var whatToWearHeaderView = self.makeWhatToWearHeaderView()
    private lazy var tableView = UITableView(frame: UIScreen.main.bounds).then {
        tableViewConfigurator.configure(tableView: $0)
        $0.register(RuleSectionTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        $0.dataSource = self
    }
    internal let landscapeLeftContainerView = UIView()
    internal let landscapeHeaderContainerView = UIView()
    internal let landscapeHorizontalSeparatorView = SeparatorView()
    private let tableViewConfigurator = RuleTableViewConfigurator()
    internal let chartParams: WeatherChartView.Params
    internal let settings: GlobalSettings
    private let viewModels: NonEmptyArray<RuleSectionViewModel>
    internal let onLabelDoubleTap: () -> Void
    internal lazy var layout = MetRulesLayout(viewSize: self.view.frame.size)
    private var portraitHeaderConstraints: [Constraint] = []

    // MARK: status bar
    internal override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: init/deinit
    internal init(
        chartParams: WeatherChartView.Params,
        settings: GlobalSettings,
        viewModels: NonEmptyArray<RuleSectionViewModel>,
        onLabelDoubleTap: @escaping () -> Void
    ) {
        self.chartParams = chartParams
        self.settings = settings
        self.viewModels = viewModels
        self.onLabelDoubleTap = onLabelDoubleTap

        super.init()
    }

    // MARK: setup
    internal func setupViews(for layout: MetRulesLayout) {
        switch layout {
            case .portrait:
                tableView.tableHeaderView = portraitHeaderView

                view.add(fullscreenSubview: tableView)
            case .landscape:
                tableView.tableHeaderView = whatToWearHeaderView

                layoutLandscapeViews(leftContainerViewSubviews: { container in
                    container.add(fullscreenSubview: tableView)
                })
        }
    }

    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()

        setupViews(for: layout)
    }

    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Analytics.record(screen: .metRules(.mainApp))
    }

    // MARK: layout
    internal override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.layoutHeaderAndFooterViews()
    }

    // MARK: rotation
    internal override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        let layout = MetRulesLayout(viewSize: size)

        coordinator.animate(alongsideTransition: { _ in
            self.transition(toLayout: layout)
        })
    }
}

// MARK: UITableViewDataSource
extension MetRulesViewController: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    internal func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell: RuleSectionTableViewCell = tableView.wtw_dequeueReusableCell(
            identifier: reuseIdentifier, indexPath: indexPath
        )
        cell.configure(with: viewModels[indexPath.row])

        return cell
    }
}
