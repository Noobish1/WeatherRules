import ErrorRecorder
import SnapKit
import Then
import UIKit
import WhatToWearCore
import WhatToWearCoreUI
import WhatToWearModels

internal final class MeasurementsViewController: CodeBackedViewController, UITableViewDelegate, UITableViewDataSource, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = MeasurementsViewController

        case tableView = "tableView"
    }

    // MARK: MeasurementsIndexPath
    internal enum MeasurementsIndexPath {
        internal enum Section: Int, CaseIterable {
            case hourlyMeasurements = 0
            case dailyMeasurements = 1

            // MARK: init
            internal static func make(rawValue: Int) -> Self {
                guard let section = Section(rawValue: rawValue) else {
                    fatalError("\(rawValue) is not a valid MeasurementsIndexPath")
                }

                return section
            }

            // MARK: computed properties
            internal var sectionTitle: String {
                switch self {
                    case .hourlyMeasurements: return NSLocalizedString("Hourly", comment: "")
                    case .dailyMeasurements: return NSLocalizedString("Daily", comment: "")
                }
            }
        }

        case hourly(Int)
        case daily(Int)

        // MARK: init
        internal init(indexPath: IndexPath) {
            switch Section.make(rawValue: indexPath.section) {
                case .hourlyMeasurements: self = .hourly(indexPath.row)
                case .dailyMeasurements: self = .daily(indexPath.row)
            }
        }
    }

    // MARK: Selection
    internal enum Selection {
        case noSelection
        indirect case selection(WeatherMeasurementViewModel)

        internal init(object: WeatherMeasurementViewModel?) {
            switch object {
                case .none: self = .noSelection
                case .some(let value): self = .selection(value)
            }
        }
    }

    // MARK: properties
    private let onSelection: (WeatherMeasurement) -> Void
    private let hourlyMeasurements: [WeatherMeasurementViewModel]
    private let dailyMeasurements: [WeatherMeasurementViewModel]
    private let reuseIdentifier = "WeatherMeasurementCell"
    private let headerReuseIdentifier = "WeatherMeasurementHeader"
    private var selected: Selection
    private let gradientView = AppBackgroundView()
    private let navBarSeparatorView = SeparatorView()
    private let preselection = Singular()
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.isAccessibilityElement = false
        $0.dataSource = self
        $0.delegate = self
        $0.register(MeasurementTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        $0.register(
            MeasurementSectionHeaderView.self,
            forHeaderFooterViewReuseIdentifier: headerReuseIdentifier
        )
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 50
        $0.rowHeight = UITableView.automaticDimension
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.tableView)

        if #available(iOS 11.0, *) {
            $0.insetsContentViewsToSafeArea = false
        }
    }

    // MARK: init/deinit
    internal init(
        system: MeasurementSystem,
        initial: WeatherMeasurement?,
        onSelection: @escaping (WeatherMeasurement) -> Void
    ) {
        self.selected = Selection(object: initial.map {
            WeatherMeasurementViewModel(measurement: $0, system: system)
        })
        self.hourlyMeasurements = WeatherMeasurement.hourlyMeasurements.map {
            WeatherMeasurementViewModel(measurement: $0, system: system)
        }
        self.dailyMeasurements = WeatherMeasurement.dailyMeasurements.map {
            WeatherMeasurementViewModel(measurement: $0, system: system)
        }
        self.onSelection = onSelection

        super.init()

        self.title = NSLocalizedString("Select Measurement", comment: "")
    }

    // MARK: setup
    private func setupViews() {
        view.add(fullscreenSubview: gradientView)

        view.add(topSeparatorView: navBarSeparatorView, beneath: self.topLayoutGuide.snp.bottom)

        view.add(subview: tableView, withConstraints: { make in
            make.top.equalTo(navBarSeparatorView.snp.bottom)
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
            make.bottom.equalToSuperview()
        })
    }

    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Analytics.record(screen: .selectMeasurement)
    }

    internal override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        preselection.performOnce {
            preselectRowIfNeeded()
        }
    }

    // MARK: preselection
    private func preselectRowIfNeeded() {
        if case .selection(let selection) = selected {
            if let row = hourlyMeasurements.firstIndex(of: selection) {
                tableView.selectRow(
                    at: IndexPath(
                        row: row,
                        section: MeasurementsIndexPath.Section.hourlyMeasurements.rawValue
                    ),
                    animated: false,
                    scrollPosition: .top
                )
            } else if let row = dailyMeasurements.firstIndex(of: selection) {
                tableView.selectRow(
                    at: IndexPath(
                        row: row,
                        section: MeasurementsIndexPath.Section.dailyMeasurements.rawValue
                    ),
                    animated: false,
                    scrollPosition: .top
                )
            }
        }
    }

    // MARK: retrieval
    private func retrieveViewModel(at indexPath: IndexPath) -> WeatherMeasurementViewModel {
        switch MeasurementsIndexPath(indexPath: indexPath) {
            case .hourly(let row): return hourlyMeasurements[row]
            case .daily(let row): return dailyMeasurements[row]
        }
    }

    // MARK: UITableViewDataSource
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return MeasurementsIndexPath.Section.allCases.count
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch MeasurementsIndexPath.Section.make(rawValue: section) {
            case .hourlyMeasurements: return hourlyMeasurements.count
            case .dailyMeasurements: return dailyMeasurements.count
        }
    }

    internal func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let viewModel = retrieveViewModel(at: indexPath)

        let cell: MeasurementTableViewCell = tableView.wtw_dequeueReusableCell(
            identifier: reuseIdentifier, indexPath: indexPath
        )
        cell.configure(with: viewModel)

        return cell
    }

    // MARK: UITableViewDelegate
    internal func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        let viewModel = retrieveViewModel(at: indexPath)

        switch selected {
            case .selection(let selected) where selected == viewModel:
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
            case .noSelection, .selection: break
        }
    }

    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = retrieveViewModel(at: indexPath)

        onSelection(viewModel.underlyingModel)
    }

    internal func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let ourSection = MeasurementsIndexPath.Section.make(rawValue: section)

        let header: MeasurementSectionHeaderView = tableView.wtw_dequeueReusableHeaderFooterView(
            identifier: headerReuseIdentifier
        )
        header.configure(withTitle: ourSection.sectionTitle)
        header.onInfoButtonTapped = { [weak self] in
            switch ourSection {
                case .hourlyMeasurements: self?.showHourlyInfoAlert()
                case .dailyMeasurements: self?.showDailyInfoAlert()
            }
        }

        return header
    }

    // MARK: showing alerts
    private func showHourlyInfoAlert() {
        let alert = AlertControllers.okAlert(
            withTitle: NSLocalizedString("Hourly Measurements", comment: ""),
            message: NSLocalizedString("Hourly measurments are measurements which are measured every hour. E.g. Cloud cover.", comment: "")
        )

        present(alert, animated: true)
    }

    private func showDailyInfoAlert() {
        let alert = AlertControllers.okAlert(
            withTitle: NSLocalizedString("Daily Measurements", comment: ""),
            message: NSLocalizedString("Daily measurements are measurements that are measured once a day. E.g. Temperature maximum.", comment: "")
        )

        present(alert, animated: true)
    }
}
