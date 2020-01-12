import UIKit
import WhatToWearCoreUI
import WhatToWearModels

internal final class RulesFullView: CodeBackedView {
    // MARK: Section
    internal enum Section {
        case ruleGroups
        case ungroupedRules

        internal var headerTitle: String {
            switch self {
                case .ruleGroups: return NSLocalizedString("Rule Groups", comment: "")
                case .ungroupedRules: return NSLocalizedString("Ungrouped Rules", comment: "")
            }
        }
    }

    // MARK: properties
    internal lazy var tableView = UITableView(frame: UIScreen.main.bounds).then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 44
        $0.rowHeight = UITableView.automaticDimension
        $0.dataSource = self
        $0.delegate = self
        $0.register(RuleTableViewCell.self, forCellReuseIdentifier: ruleCellReuseIdentifier)
        $0.register(TextTableViewCell.self, forCellReuseIdentifier: groupCellReuseIdentifier)
    }
    internal weak var delegate: RulesFullViewDelegate?

    private let ruleCellReuseIdentifier = "RuleCell"
    private let groupCellReuseIdentifier = "RuleGroupCell"
    private var storedRules: StoredRulesViewModel

    // MARK: init/deinit
    internal init(storedRules: NonEmptyStoredRules, system: MeasurementSystem) {
        self.storedRules = StoredRulesViewModel(
            storedRules: storedRules.emptyableRules,
            system: system
        )

        super.init(frame: .zero)

        setupViews()
    }

    // MARK: setup
    private func setupViews() {
        add(fullscreenSubview: tableView)
    }

    // MARK: update
    internal func update(with rules: NonEmptyStoredRules, system: MeasurementSystem) {
        self.storedRules = StoredRulesViewModel(
            storedRules: rules.emptyableRules,
            system: system
        )

        tableView.reloadData()
    }
}

// MARK: UITableViewDataSource
extension RulesFullView: UITableViewDataSource {
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return storedRules.numberOfSections
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storedRules.numberOfRows(inSection: section)
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch storedRules.rulesSection(forIndex: indexPath.section) {
            case .ruleGroups:
                let cell: TextTableViewCell = tableView.wtw_dequeueReusableCell(identifier: groupCellReuseIdentifier, indexPath: indexPath)
                cell.configure(
                    withText: storedRules.ruleGroups[indexPath.row].name,
                    insets: UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
                )

                return cell
            case .ungroupedRules:
                let cell: RuleTableViewCell = tableView.wtw_dequeueReusableCell(identifier: ruleCellReuseIdentifier, indexPath: indexPath)
                cell.configure(with: storedRules.ungroupedRules[indexPath.row])

                return cell
        }
    }
}

// MARK: UITableViewDelegate
extension RulesFullView: UITableViewDelegate {
    internal func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        let rulesSection = storedRules.rulesSection(forIndex: section)

        return delegate?.tableView(tableView, heightForHeaderInSection: rulesSection) ?? 0
    }

    internal func tableView(
        _ tableView: UITableView,
        estimatedHeightForHeaderInSection section: Int
    ) -> CGFloat {
        let rulesSection = storedRules.rulesSection(forIndex: section)

        return delegate?.tableView(tableView, estimatedHeightForHeaderInSection: rulesSection) ?? 0
    }

    internal func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        return delegate?.tableView(tableView, viewForHeaderInSection: storedRules.rulesSection(forIndex: section))
    }

    internal func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        switch storedRules.rulesSection(forIndex: indexPath.section) {
            case .ruleGroups:
                let group = storedRules.ruleGroups[indexPath.row].underlyingModel

                delegate?.fullView(commitEditingStyle: editingStyle, for: group)
            case .ungroupedRules:
                let rule = storedRules.ungroupedRules[indexPath.row].underlyingModel

            delegate?.fullView(commitEditingStyle: editingStyle, for: rule)
        }
    }

    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch storedRules.rulesSection(forIndex: indexPath.section) {
            case .ruleGroups:
                let group = storedRules.ruleGroups[indexPath.row].underlyingModel

                delegate?.fullView(didSelectGroup: group)
            case .ungroupedRules:
                let rule = storedRules.ungroupedRules[indexPath.row].underlyingModel

                delegate?.fullView(didSelectRule: rule)
        }
    }
}
