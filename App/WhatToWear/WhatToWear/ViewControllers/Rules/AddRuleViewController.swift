import ErrorRecorder
import SnapKit
import Then
import UIKit
import WhatToWearCoreComponents
import WhatToWearCoreUI
import WhatToWearModels

internal final class AddRuleViewController: CodeBackedViewController, NavStackEmbedded, Accessible, RulesAddViewControllerProtocol {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = AddRuleViewController

        case contentView = "contentView"
    }

    // MARK: State
    internal struct State: Equatable, RulesAddViewControllerStateProtocol {
        // MARK: typealias
        internal typealias Object = Rule
        
        // MARK: properties
        internal var name: String?
        internal var conditions: [ConditionViewModel]

        // MARK: computed properties
        internal static var `default`: Self {
            return State(name: nil, conditions: [])
        }

        fileprivate var viewControllerTitle: String {
            if self == State.default {
                return NSLocalizedString("Add Rule", comment: "")
            } else {
                return NSLocalizedString("Edit Rule", comment: "")
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
        fileprivate init(name: String?, conditions: [ConditionViewModel]) {
            self.name = name
            self.conditions = conditions
        }

        internal init(object: Rule, system: MeasurementSystem) {
            self.name = object.name
            self.conditions = object.conditions.map {
                ConditionViewModel(condition: $0, system: system)
            }
        }
    }

    // MARK: properties
    private let conditionsReuseIdentifier = "ConditionsCell"
    private var state: State
    private let onDone: (Rule) -> Void
    private let measurementSystem: MeasurementSystem
    private lazy var contentView = AddRuleContentView(
        name: self.state.name,
        conditions: self.state.conditions,
        configureEmptyView: { [weak self] emptyView in
            self?.setup(emptyView: emptyView)
        },
        configureFullView: { [weak self] fullView in
            self?.setup(fullView: fullView)
        },
        onNameChange: { [weak self] newName in
            self?.state.name = newName
        },
        onAdd: { [weak self] in
            self?.addButtonTapped()
        }
    ).then {
        $0.addConditionButton.addTarget(self, action: #selector(addConditionButtonTapped), for: .touchUpInside)
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.contentView)
    }
    private let backgroundView = BasicBackgroundView()

    // MARK: init/deinit
    internal convenience init(onDone: @escaping (Rule) -> Void) {
        self.init(state: .default, onDone: onDone)
    }
    
    internal init(state: State = .default, onDone: @escaping (Rule) -> Void) {
        self.state = state
        self.measurementSystem = GlobalSettingsController.shared.retrieve().measurementSystem
        self.onDone = onDone

        super.init()

        self.title = state.viewControllerTitle
    }

    // MARK: setup
    private func setupViews() {
        view.add(fullscreenSubview: backgroundView)

        view.add(subview: contentView, withConstraints: { make in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
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

    private func setup(fullView: AddRuleFullView) {
        fullView.tableView.register(ConditionTableViewCell.self, forCellReuseIdentifier: conditionsReuseIdentifier)
        fullView.tableView.dataSource = self
        fullView.tableView.delegate = self
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

        Analytics.record(screen: .addRule)
    }

    // MARK: interface actions
    @objc
    private func helpButtonTapped() {
        let alert = AlertControllers.okAlert(
            withTitle: NSLocalizedString("Conditions", comment: ""),
            message: NSLocalizedString("""
                Conditions make up Rules and are comprised of a measurement, a symbol and a value.

                E.g. When Temperature (Measurement) is greater than (Symbol) 15°C (Value)
            """, comment: "")
        )

        present(alert, animated: true)
    }

    @objc
    private func addConditionButtonTapped() {
        let vc = AddConditionViewController(onDone: { [weak self] condition in
            guard let strongSelf = self else { return }

            strongSelf.configureContentView(afterUpdatingConditions: {
                $0.byAppending(ConditionViewModel(
                    condition: condition,
                    system: strongSelf.measurementSystem
                ))
            })
            strongSelf.navController.popViewController(animated: true)

            // Analytics always use metric
            Analytics.record(event: .conditionAdded(
                ConditionViewModel.title(for: condition, system: .metric),
                measurement: condition.measurement.name
            ))
        })

        navController.pushViewController(vc, animated: true)
    }

    @objc
    private func addButtonTapped() {
        switch Rule.create(with: state) {
            case .failure(let error):
                showAlert(for: error)
            case .success(let rule):
                onDone(rule)
        }
    }

    // MARK: showing alerts
    private func showAlert(for error: Rule.CreationError) {
        let alert = AlertControllers.okAlert(
            withTitle: NSLocalizedString("Rule incomplete", comment: ""),
            message: error.alertText
        )

        present(alert, animated: true)
    }

    // MARK: configuration
    private func configureContentView(
        afterUpdatingConditions update: ([ConditionViewModel]) -> [ConditionViewModel]
    ) {
        state.conditions = update(state.conditions)
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
extension AddRuleViewController: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.conditions.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ConditionTableViewCell = tableView.wtw_dequeueReusableCell(identifier: conditionsReuseIdentifier, indexPath: indexPath)
        cell.configure(with: state.conditions[indexPath.row])

        return cell
    }
}

// MARK: UITableViewDelegate
extension AddRuleViewController: UITableViewDelegate {
    internal func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard editingStyle == .delete else { return }

        state.conditions.remove(at: indexPath.row)
        tableView.reloadData()
    }

    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let conditionVM = state.conditions[indexPath.row]

        let vc = AddConditionViewController(
            state: .condition(conditionVM.underlyingModel),
            onDone: { [weak self] returnedCondition in
                guard let strongSelf = self else { return }

                let returnedVM = ConditionViewModel(
                    condition: returnedCondition,
                    system: strongSelf.measurementSystem
                )

                strongSelf.configureContentView(afterUpdatingConditions: {
                    $0.byReplacing(conditionVM, with: returnedVM)
                })
                strongSelf.navController.popViewController(animated: true)
            }
        )

        navController.pushViewController(vc, animated: true)
    }
}
