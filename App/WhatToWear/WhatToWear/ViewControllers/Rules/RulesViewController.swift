import ErrorRecorder
import RxSwift
import StoreKit
import UIKit
import WhatToWearCore
import WhatToWearCoreComponents
import WhatToWearCoreUI
import WhatToWearModels

internal final class RulesViewController: CodeBackedViewController, NavStackEmbedded, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = RulesViewController

        case contentView = "contentView"
    }

    // MARK: properties
    private let rulesHeaderReuseIdentifier = "RuleHeader"
    private let backgroundView = BasicBackgroundView()
    private lazy var contentView = RulesContentView(
        rules: RulesController.shared.retrieve(),
        system: self.measurementSystem,
        configureEmptyView: { [weak self] emptyView in
            self?.setup(emptyView: emptyView)
        },
        configureFullView: { [weak self] fullView in
            self?.setup(fullView: fullView)
        },
        onAddRule: { [weak self] in
            self?.addRuleButtonTapped()
        }
    ).then {
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.contentView)
        $0.addGroupButton.addTarget(self, action: #selector(addGroupButtonTapped), for: .touchUpInside)
    }
    private let measurementSystem: MeasurementSystem

    // MARK: status bar
    internal override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: init
    internal override init() {
        self.measurementSystem = GlobalSettingsController.shared.retrieve().measurementSystem

        super.init()

        self.title = NSLocalizedString("Rules", comment: "")
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

    private func setup(fullView: RulesFullView) {
        fullView.tableView.register(
            BasicSectionHeaderView.self,
            forHeaderFooterViewReuseIdentifier: rulesHeaderReuseIdentifier
        )
        fullView.delegate = self
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
    }

    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navController.setNavigationBarHidden(false, animated: animated)
    }

    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Analytics.record(screen: .rules)
    }

    // MARK: interface actions
    @objc
    private func helpButtonTapped() {
        present(AlertControllers.ruleInfoAlert(), animated: true)
    }

    // MARK: interface actions
    @objc
    private func doneButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc
    private func addRuleButtonTapped() {
        presentAdditionViewController(
            ofType: AddRuleViewController.self,
            initialObject: nil,
            createNewStoredRules: { rule in
                RulesController.shared.add(rule: rule)
            },
            createAnalyticsEvent: { rule in
                .ruleAdded(
                    name: rule.name,
                    numberOfConditions: rule.conditions.count
                )
            },
            requestReview: true
        )
    }
    
    @objc
    private func addGroupButtonTapped() {
        presentAdditionViewController(
            ofType: AddRuleGroupViewController.self,
            initialObject: nil,
            createNewStoredRules: { groupContainer in
                RulesController.shared.add(groupContainer: groupContainer)
            },
            createAnalyticsEvent: { groupContainer in
                .ruleGroupAdded(
                    name: groupContainer.group.name,
                    numberOfRules: groupContainer.group.rules.count
                )
            },
            requestReview: true
        )
    }

    // MARK: presenting
    private func presentAdditionViewController<ViewController: RulesAddViewControllerProtocol>(
        ofType viewControllerType: ViewController.Type,
        initialObject: ViewController.State.Object?,
        createNewStoredRules: @escaping (ViewController.Object) -> StoredRules,
        createAnalyticsEvent: ((ViewController.Object) -> AnalyticsEvent)?,
        requestReview: Bool
    ) {
        let vc = viewControllerType.init(
            state: initialObject.map { .init(object: $0, system: measurementSystem) } ?? .default,
            onDone: { [contentView, measurementSystem, navController] object in
                let newStoredRules = createNewStoredRules(object)
                
                contentView.update(with: newStoredRules, system: measurementSystem)
                
                if let analyticsEvent = createAnalyticsEvent?(object) {
                    Analytics.record(event: analyticsEvent)
                }
                
                navController.popViewController(animated: true)
                
                if requestReview, #available(iOS 10.3, *), newStoredRules.allRules.count > 1 {
                    SKStoreReviewController.requestReview()
                    Analytics.record(event: .reviewPromptPotentiallyShown)
                }
            }
        )
        
        navController.pushViewController(vc, animated: true)
    }

    // MARK: inset updates
    internal override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11, *) {
            contentView.update(bottomInset: view.safeAreaInsets.bottom)
        }
    }
}

// MARK: UITableViewDelegate
extension RulesViewController: RulesFullViewDelegate {
    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: RulesFullView.Section) -> CGFloat {
        return UITableView.automaticDimension
    }

    internal func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: RulesFullView.Section) -> CGFloat {
        return 44
    }

    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: RulesFullView.Section) -> UIView? {
        let header: BasicSectionHeaderView = tableView.wtw_dequeueReusableHeaderFooterView(
            identifier: rulesHeaderReuseIdentifier
        )
        header.configure(withTitle: section.headerTitle)

        return header
    }

    internal func fullView(commitEditingStyle editingStyle: UITableViewCell.EditingStyle, for group: RuleGroup) {
        guard editingStyle == .delete else { return }

        contentView.update(
            with: RulesController.shared.remove(group: group),
            system: measurementSystem
        )
    }

    internal func fullView(commitEditingStyle editingStyle: UITableViewCell.EditingStyle, for rule: Rule) {
        guard editingStyle == .delete else { return }

        contentView.update(
            with: RulesController.shared.remove(rule: rule),
            system: measurementSystem
        )
    }
    
    internal func fullView(didSelectGroup group: RuleGroup) {
        presentAdditionViewController(
            ofType: AddRuleGroupViewController.self,
            initialObject: group,
            createNewStoredRules: { groupContainer in
                RulesController.shared.replace(group: group, withContainer: groupContainer)
            },
            createAnalyticsEvent: nil,
            requestReview: false
        )
    }

    internal func fullView(didSelectRule rule: Rule) {
        presentAdditionViewController(
            ofType: AddRuleViewController.self,
            initialObject: rule,
            createNewStoredRules: { returnedRule in
                RulesController.shared.replace(rule: rule, with: returnedRule)
            },
            createAnalyticsEvent: nil,
            requestReview: false
        )
    }
}
