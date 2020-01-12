import UIKit
import WhatToWearCommonCore
import WhatToWearCore
import WhatToWearCoreUI

// MARK: AddExistingRulesFullView
internal final class AddExistingRulesFullView: CodeBackedView {
    // MARK: properties
    private let ruleCellReuseIdentifier = "RuleCell"
    internal lazy var tableView = UITableView(frame: UIScreen.main.bounds).then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 44
        $0.rowHeight = UITableView.automaticDimension
        $0.dataSource = self
        $0.allowsMultipleSelection = true
        $0.register(ExistingRuleTableViewCell.self, forCellReuseIdentifier: ruleCellReuseIdentifier)
    }
    internal lazy var addRulesButton = BottomAnchoredButton(
        bottomInset: self.wtw_bottomSafeInset,
        onTap: { [weak self] in
            self?.addRulesButtonTapped()
        }
    ).then {
        $0.update(title: NSLocalizedString("Add Rules", comment: ""))
    }
    private var rules: NonEmptyArray<RuleViewModel>
    private let onRulesSelected: (NonEmptyArray<RuleViewModel>) -> Void
    private let onNoRulesSelected: () -> Void

    // MARK: init
    internal init(
        rules: NonEmptyArray<RuleViewModel>,
        onRulesSelected: @escaping (NonEmptyArray<RuleViewModel>) -> Void,
        onNoRulesSelected: @escaping () -> Void
    ) {
        self.rules = rules
        self.onRulesSelected = onRulesSelected
        self.onNoRulesSelected = onNoRulesSelected

        super.init(frame: .zero)

        setupViews()
    }

    // MARK: setup
    private func setupViews() {
        add(subview: tableView, withConstraints: { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        })

        add(subview: addRulesButton, withConstraints: { make in
            make.top.equalTo(tableView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        })
    }

    // MARK: interface actions
    @objc
    private func addRulesButtonTapped() {
        // We default to an empty array because it returns nil when empty
        let selectedIndexPaths = tableView.indexPathsForSelectedRows ?? []

        guard let nonEmptyIndexPaths = NonEmptyArray(array: selectedIndexPaths) else {
            onNoRulesSelected()

            return
        }

        let selectedRules = nonEmptyIndexPaths.map { rules[$0.row] }

        onRulesSelected(selectedRules)
    }

    // MARK: update
    internal func update(with rules: NonEmptyArray<RuleViewModel>) {
        self.rules = rules

        tableView.reloadData()
    }

    internal func update(bottomInset: CGFloat) {
        addRulesButton.update(bottomInset: bottomInset)
    }
}

// MARK: UITableViewDataSource
extension AddExistingRulesFullView: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rules.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ExistingRuleTableViewCell = tableView.wtw_dequeueReusableCell(identifier: ruleCellReuseIdentifier, indexPath: indexPath)
        cell.configure(with: rules[indexPath.row])

        return cell
    }
}
