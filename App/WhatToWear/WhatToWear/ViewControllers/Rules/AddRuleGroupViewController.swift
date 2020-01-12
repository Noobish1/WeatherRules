import ErrorRecorder
import SnapKit
import Then
import UIKit
import WhatToWearCoreComponents
import WhatToWearCoreUI
import WhatToWearModels

// MARK: AddRuleGroupViewController
internal final class AddRuleGroupViewController: CodeBackedViewController, NavStackEmbedded, Accessible, RulesAddViewControllerProtocol {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = AddRuleGroupViewController

        case contentView = "contentView"
    }

    // MARK: State
    internal struct State: Equatable, RulesAddViewControllerStateProtocol {
        internal typealias Object = RuleGroup
        
        // MARK: properties
        internal var name: String?
        internal var rules: [RuleViewModel]

        // MARK: computed properties
        internal static var `default`: Self {
            return State(name: nil, rules: [])
        }

        fileprivate var viewControllerTitle: String {
            if self == State.default {
                return NSLocalizedString("Add Rule Group", comment: "")
            } else {
                return NSLocalizedString("Edit Rule Group", comment: "")
            }
        }

        internal var initialAddButtonTitle: String {
            if self == State.default {
                return NSLocalizedString("Add", comment: "")
            } else {
                return NSLocalizedString("Save", comment: "")
            }
        }

        // MARK: init
        private init(name: String?, rules: [RuleViewModel]) {
            self.name = name
            self.rules = rules
        }

        internal init(object: RuleGroup, system: MeasurementSystem) {
            self.name = object.name
            self.rules = object.rules.map {
                RuleViewModel(rule: $0, system: system, isExisting: false)
            }
        }
    }
    // MARK: properties
    private let backgroundView = BasicBackgroundView()
    private let headerReuseIdentifier = "ruleGroupHeaderReuseIdentifier"
    private let ruleCellReuseIdentifier = "RuleCell"
    private lazy var contentView = AddRuleGroupContentView(
        name: self.state.name,
        rules: self.state.rules,
        configureEmptyView: { [weak self] emptyView in
            self?.setup(emptyView: emptyView)
        },
        configureFullView: { [weak self] fullView in
            self?.setup(fullView: fullView)
        },
        onNameChange: { [weak self] name in
            self?.state.name = name
        },
        onAdd: { [weak self] in
            self?.addButtonTapped()
        }
    ).then {
        $0.newRuleButton.addTarget(self, action: #selector(addNewRuleButtonTapped), for: .touchUpInside)
        $0.existingRuleButton.addTarget(self, action: #selector(addExistingRuleButtonTapped), for: .touchUpInside)
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.contentView)
    }
    private var state: State
    private let onDone: (RuleGroupContainer) -> Void
    private let measurementSystem: MeasurementSystem

    // MARK: init/deinit
    internal convenience init(onDone: @escaping (RuleGroupContainer) -> Void) {
        self.init(state: .default, onDone: onDone)
    }
    
    internal init(state: State = .default, onDone: @escaping (RuleGroupContainer) -> Void) {
        self.state = state
        self.onDone = onDone
        self.measurementSystem = GlobalSettingsController.shared.retrieve().measurementSystem

        super.init()

        self.title = state.viewControllerTitle
    }

    // MARK: setup
    private func setupViews() {
        view.add(fullscreenSubview: backgroundView)

        view.add(subview: contentView, withConstraints: { make in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
            make.bottom.equalToSuperview()
        })
    }

    private func setup(emptyView: RuleEmptyView) {
        emptyView.helpButton.addTarget(
            self,
            action: #selector(helpButtonTapped),
            for: .touchUpInside
        )
    }

    private func setup(fullView: AddRuleGroupFullView) {
        fullView.tableView.delegate = self
        fullView.tableView.register(
            RuleGroupHeaderView.self,
            forHeaderFooterViewReuseIdentifier: headerReuseIdentifier
        )
        fullView.tableView.dataSource = self
        fullView.tableView.register(
            RuleGroupRuleTableViewCell.self,
            forCellReuseIdentifier: ruleCellReuseIdentifier
        )
    }

    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupNavigation()

        contentView.configure(with: state)
    }

    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Analytics.record(screen: .addRuleGroup)
    }

    // MARK: interface actions
    @objc
    private func addNewRuleButtonTapped() {
        let vc = AddRuleViewController(onDone: { [weak self] rule in
            guard let strongSelf = self else { return }

            strongSelf.configureContentView(afterUpdatingRules: {
                $0.byAppending(RuleViewModel(
                    rule: rule, system: strongSelf.measurementSystem, isExisting: false
                ))
            })

            strongSelf.navController.popViewController(animated: true)
        })

        navController.pushViewController(vc, animated: true)
    }

    @objc
    private func addExistingRuleButtonTapped() {
        let vc = AddExistingRulesViewController(
            measurementSystem: measurementSystem,
            onRulesSelected: { [weak self] rules in
                guard let strongSelf = self else { return }

                strongSelf.configureContentView(afterUpdatingRules: {
                    $0.byAppending(rules.toArray())
                })

                strongSelf.navController.popViewController(animated: true)
            }
        )

        navController.pushViewController(vc, animated: true)
    }

    @objc
    private func helpButtonTapped() {
        present(AlertControllers.ruleGroupInfoAlert(), animated: true)

        Analytics.record(event: .ruleGroupHelpButtonTapped)
    }

    @objc
    private func priorityInfoButtonTapped() {
        present(AlertControllers.priorityInfoAlert(), animated: true)

        Analytics.record(event: .priorityInfoButtonTapped)
    }

    @objc
    private func addButtonTapped() {
        switch RuleGroup.create(with: state) {
            case .failure(let error):
                showAlert(for: error)
            case .success(let group):
                onDone(group)
        }
    }

    // MARK: showing alerts
    private func showAlert(for error: RuleGroup.CreationError) {
        let alert = AlertControllers.okAlert(
            withTitle: NSLocalizedString("Rule Group incomplete", comment: ""),
            message: error.alertText
        )

        present(alert, animated: true)
    }

    // MARK: update
    private func configureContentView(afterUpdatingRules update: ([RuleViewModel]) -> [RuleViewModel]) {
        state.rules = update(state.rules)
        contentView.configure(with: state)
    }

    // MARK: inset updates
    internal override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11, *) {
            contentView.update(bottomInset: view.safeAreaInsets.bottom)
        }
    }
}

// MARK: UITableViewDataSource
extension AddRuleGroupViewController: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    internal func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        configureContentView(afterUpdatingRules: {
            $0.bySwapping(
                sourceIndex: sourceIndexPath.row,
                withDestinationIndex: destinationIndexPath.row
            )
        })
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.rules.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RuleGroupRuleTableViewCell = tableView.wtw_dequeueReusableCell(identifier: ruleCellReuseIdentifier, indexPath: indexPath)
        cell.configure(with: state.rules[indexPath.row], priority: indexPath.row + 1)

        return cell
    }
}

// MARK: UITableViewDelegate
extension AddRuleGroupViewController: UITableViewDelegate {
    internal func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let header: RuleGroupHeaderView = tableView.wtw_dequeueReusableHeaderFooterView(identifier: headerReuseIdentifier)
        header.onInfoButtonTapped = { [weak self] in
            self?.priorityInfoButtonTapped()
        }

        return header
    }

    internal func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard editingStyle == .delete else { return }

        configureContentView(afterUpdatingRules: {
            $0.byRemoving(at: [indexPath.row])
        })
    }

    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let ruleVM = state.rules[indexPath.row]

        let vc = AddRuleViewController(
            state: .init(object: ruleVM.underlyingModel, system: measurementSystem),
            onDone: { [weak self] returnedRule in
                guard let strongSelf = self else { return }

                let returnedVM = RuleViewModel(
                    rule: returnedRule,
                    system: strongSelf.measurementSystem,
                    isExisting: ruleVM.isExisting
                )

                strongSelf.configureContentView(afterUpdatingRules: {
                    $0.byReplacing(ruleVM, with: returnedVM)
                })

                strongSelf.navController.popViewController(animated: true)
            }
        )

        navController.pushViewController(vc, animated: true)
    }
}
