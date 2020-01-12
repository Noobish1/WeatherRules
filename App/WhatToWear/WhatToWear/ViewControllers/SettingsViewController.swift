import ErrorRecorder
import UIKit
import WhatToWearCore
import WhatToWearCoreComponents
import WhatToWearCoreUI
import WhatToWearEnvironment
import WhatToWearModels

// MARK: SettingsViewController
internal final class SettingsViewController: CodeBackedViewController, NavStackEmbedded {
    // MARK: properties
    private let backgroundView = BasicBackgroundView()
    private let navBarBottomSeparatorView = SeparatorView()
    private let detailCellReuseIdentifier = "detailCell"
    private let textCellReuseIdentifier = "textCell"
    private let measurementSystemCellReuseIdentifier = "measurementSystemCell"
    private let temperatureTypeCellReuseIdentifier = "temperatureTypeCell"
    private let windTypeCellReuseIdentifier = "windTypeCell"
    private let switchCellReuseIdentifier = "switchCell"
    private let headerReuseIdentifier = "settingsHeader"
    private lazy var tableView = UITableView(frame: UIScreen.main.bounds).then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 44
        $0.rowHeight = UITableView.automaticDimension
        $0.dataSource = self
        $0.delegate = self
        $0.delaysContentTouches = false
        $0.register(TextTableViewCell.self, forCellReuseIdentifier: textCellReuseIdentifier)
        $0.register(DetailTableViewCell.self, forCellReuseIdentifier: detailCellReuseIdentifier)
        $0.register(
            BasicSectionHeaderView.self,
            forHeaderFooterViewReuseIdentifier: headerReuseIdentifier
        )
        $0.register(
            SegmentedControlCell<MeasurementSystemViewModel>.self,
            forCellReuseIdentifier: measurementSystemCellReuseIdentifier
        )
        $0.register(
            SegmentedControlCell<TemperatureTypeViewModel>.self,
            forCellReuseIdentifier: temperatureTypeCellReuseIdentifier
        )
        $0.register(
            SegmentedControlCell<WindTypeViewModel>.self,
            forCellReuseIdentifier: windTypeCellReuseIdentifier
        )
        $0.register(
            SwitchTableViewCell.self, forCellReuseIdentifier: switchCellReuseIdentifier
        )
    }

    // MARK: status bar
    internal override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: init
    internal override init() {
        super.init()

        self.title = NSLocalizedString("Settings", comment: "")
    }

    // MARK: setup
    private func setupViews() {
        view.add(fullscreenSubview: backgroundView)

        view.add(
            topSeparatorView: navBarBottomSeparatorView,
            beneath: self.topLayoutGuide.snp.bottom
        )

        view.add(subview: tableView, withConstraints: { make in
            make.top.equalTo(navBarBottomSeparatorView.snp.bottom)
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
            make.bottom.equalToSuperviewOrSafeAreaLayoutGuide()
        })
    }

    private func setupTableHeaderView() {
        let globalSettings = GlobalSettingsController.shared.retrieve()

        switch globalSettings.updateWarningState {
            case .show(let latestUpdate):
                tableView.tableHeaderView = UpdateWarningHeaderView(
                    latestUpdate: latestUpdate,
                    onButtonTap: { [weak self] button in
                        self?.onUpdateWarningButtonTapped(button, latestUpdate: latestUpdate)
                    }
                )

                tableView.layoutHeaderAndFooterViews()
            case .hide:
                break
        }
    }
    
    private func setupBarButtonItemsIfNeeded() {
        guard case .pad = InterfaceIdiom.current else {
            return
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped)
        )
    }

    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupNavigation()
        setupBarButtonItemsIfNeeded()
        setupTableHeaderView()
    }

    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navController.setNavigationBarHidden(false, animated: animated)
    }

    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Analytics.record(screen: .settings)
    }

    // MARK: creating cells
    private func configCell<ViewModel: FiniteSetViewModelProtocol>(
        for row: SettingsConfigRow,
        selectedValue: ViewModel,
        at indexPath: IndexPath,
        identifier: String,
        keyPath: WritableKeyPath<GlobalSettings, ViewModel.UnderlyingModel>,
        makeAnalyticsEvent: @escaping (ViewModel.UnderlyingModel) -> AnalyticsEvent
    ) -> SegmentedControlCell<ViewModel> {
        let cell: SegmentedControlCell<ViewModel> = tableView.wtw_dequeueReusableCell(
            identifier: identifier, indexPath: indexPath
        )
        
        cell.configure(
            title: row.title,
            selectedValue: selectedValue,
            onSegmentChange: { [weak self] newValue in
                self?.updateSetting(
                    withNewValue: newValue.underlyingModel,
                    for: keyPath,
                    makeAnalyticsEvent: makeAnalyticsEvent
                )
            }
        )
        
        return cell
    }
    
    private func configCell(for row: SettingsConfigRow, at indexPath: IndexPath) -> UITableViewCell {
        let settings = GlobalSettingsController.shared.retrieve()
        
        switch row {
            case .units:
                return configCell(
                    for: row,
                    selectedValue: MeasurementSystemViewModel(model: settings.measurementSystem),
                    at: indexPath,
                    identifier: measurementSystemCellReuseIdentifier,
                    keyPath: \.measurementSystem,
                    makeAnalyticsEvent: { .measurementSystemChanged($0.rawValue) }
                )
            case .temperatureType:
                return configCell(
                    for: row,
                    selectedValue: TemperatureTypeViewModel(model: settings.temperatureType),
                    at: indexPath,
                    identifier: temperatureTypeCellReuseIdentifier,
                    keyPath: \.temperatureType,
                    makeAnalyticsEvent: { .temperatureTypeChanged($0.rawValue) }
                )
            case .windType:
                return configCell(
                    for: row,
                    selectedValue: WindTypeViewModel(model: settings.windType),
                    at: indexPath,
                    identifier: windTypeCellReuseIdentifier,
                    keyPath: \.windType,
                    makeAnalyticsEvent: { .windTypeChanged($0.rawValue) }
                )
            case .whatsNewOnLaunch:
                return switchCell(
                    for: row,
                    at: indexPath,
                    keyPath: \.whatsNewOnLaunch,
                    makeAnalyticsEvent: { newValue in
                        .whatsNewOnLaunchChanged(newValue)
                    }
                )
            case .chartComponents:
                return detailCell(for: row, indexPath: indexPath)
            case .appBackground:
                return detailCell(for: row, indexPath: indexPath)
        }
    }
    
    private func switchCell(
        for row: SettingsConfigRow,
        at indexPath: IndexPath,
        keyPath: WritableKeyPath<GlobalSettings, Bool>,
        makeAnalyticsEvent: @escaping (Bool) -> AnalyticsEvent
    ) -> UITableViewCell {
        let cell: SwitchTableViewCell = tableView.wtw_dequeueReusableCell(
            identifier: switchCellReuseIdentifier,
            indexPath: indexPath
        )
        cell.configure(
            withTitle: row.title,
            isOn: GlobalSettingsController.shared.retrieve()[keyPath: keyPath],
            onValueChanged: { [weak self] newValue in
                self?.updateSetting(withNewValue: newValue, for: keyPath, makeAnalyticsEvent: makeAnalyticsEvent)
            }
        )
        
        return cell
    }
    
    private func attributedCell(
        for row: SettingsAttributedCellProtocol,
        indexPath: IndexPath
    ) -> UITableViewCell {
        let cell: TextTableViewCell = tableView.wtw_dequeueReusableCell(
            identifier: textCellReuseIdentifier,
            indexPath: indexPath
        )
        cell.configure(withText: row.attributedText)

        return cell
    }

    private func detailCell(
        for row: SettingsDetailCellProtocol,
        indexPath: IndexPath
    ) -> UITableViewCell {
        let cell: DetailTableViewCell = tableView.wtw_dequeueReusableCell(
            identifier: detailCellReuseIdentifier,
            indexPath: indexPath
        )
        cell.configure(withText: row.title)

        return cell
    }

    // MARK: updating
    private func updateSetting<T>(
        withNewValue newValue: T,
        for keyPath: WritableKeyPath<GlobalSettings, T>,
        makeAnalyticsEvent: @escaping (T) -> AnalyticsEvent
    ) {
        let newSettings = GlobalSettingsController.shared.updateAndSaveSetting(
            withNewValue: newValue,
            for: keyPath
        )
        
        let analyticsEvent = makeAnalyticsEvent(newSettings[keyPath: keyPath])
        
        Analytics.record(event: analyticsEvent)
    }
    
    // MARK: interface actions
    @objc
    private func doneButtonTapped() {
        dismiss(animated: true)
    }
    
    private func onUpdateWarningButtonTapped(
        _ button: UpdateWarningHeaderView.Button,
        latestUpdate: LatestAppUpdate
    ) {
        switch button {
            case .dismiss:
                // We use .some here because swift struggles
                // to allow non-optional values where it accepts optionals
                updateSetting(withNewValue: .some(latestUpdate), for: \.lastSeenUpdate, makeAnalyticsEvent: { _ in
                    .lastSeenUpdateChanged(latestUpdate.version.shortStringRepresentation)
                })

                tableView.tableHeaderView = nil
            case .appStore:
                UIApplication.shared.open(Environment.Variables.AppStoreURL)
        }
    }

    // MARK: opening links
    private func openSettingsURL(_ url: HardCodedURL) {
        UIApplication.shared.open(url)

        Analytics.record(event: .settingsLinkTapped(url.analyticsValue))
    }

    // MARK: Selection
    private func handleSelection(ofSocialRow row: SettingsSocialRow) {
        switch row {
            case .appTwitter:
                openSettingsURL(HardCodedURL("https://twitter.com/WeatherRulesApp"))
            case .devTwitter:
                openSettingsURL(HardCodedURL("https://twitter.com/Noobish1"))
            case .email:
                openSettingsURL(HardCodedURL("mailto:weatherrulesapp@gmail.com"))
        }
    }

    private func handleSelection(ofOtherRow row: SettingsOtherRow) {
        switch row {
            case .leaveAReview:
                openSettingsURL(Environment.Variables.AppStoreReviewsURL)
            case .whatsNew:
                let vc = WhatsNewViewController(context: .settings)

                navController.pushViewController(vc, animated: true)
            case .darkSkyAttribution:
                openSettingsURL(HardCodedURL("https://darksky.net/poweredby/"))
        }
    }

    private func handleSelection(ofConfigRow row: SettingsConfigRow) {
        switch row {
            case .units, .temperatureType, .windType, .whatsNewOnLaunch:
                break
            case .chartComponents:
                let vc = ChartConfigViewController(
                    settings: GlobalSettingsController.shared.retrieve(),
                    onComplete: { [navController] newSettings in
                        GlobalSettingsController.shared.save(newSettings)
                        
                        navController.popViewController(animated: true)
                    }
                )

                navController.pushViewController(vc, animated: true)
            case .appBackground:
                let vc = AppBackgroundsViewController()

                navController.pushViewController(vc, animated: true)
        }
    }
}

// MARK: UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsIndexPath.Section.allCases.count
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsIndexPath.Section.make(rawValue: section).numberOfRows
    }

    internal func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        switch SettingsIndexPath(indexPath: indexPath) {
            case .config(let row):
                return configCell(for: row, at: indexPath)
            case .social(let row):
                return attributedCell(for: row, indexPath: indexPath)
            case .other(let row):
                return attributedCell(for: row, indexPath: indexPath)
        }
    }
}

// MARK: UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch SettingsIndexPath(indexPath: indexPath) {
            case .config(let row):
                handleSelection(ofConfigRow: row)
            case .social(let row):
                handleSelection(ofSocialRow: row)
            case .other(let row):
                handleSelection(ofOtherRow: row)
        }
    }

    internal func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let section = SettingsIndexPath.Section.make(rawValue: section)

        let header: BasicSectionHeaderView = tableView.wtw_dequeueReusableHeaderFooterView(
            identifier: headerReuseIdentifier
        )
        header.configure(withTitle: section.sectionTitle)

        return header
    }

    internal func tableView(
        _ tableView: UITableView,
        shouldHighlightRowAt indexPath: IndexPath
    ) -> Bool {
        return SettingsIndexPath(indexPath: indexPath).shouldHighight
    }
}
