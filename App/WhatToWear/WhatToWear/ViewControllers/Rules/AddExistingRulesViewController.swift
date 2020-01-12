import ErrorRecorder
import UIKit
import WhatToWearCommonCore
import WhatToWearCore
import WhatToWearCoreComponents
import WhatToWearCoreUI
import WhatToWearModels

// MARK: AddExistingRulesViewController
internal final class AddExistingRulesViewController: CodeBackedViewController, NavStackEmbedded, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = AddExistingRulesViewController

        case contentView = "contentView"
    }
    
    // MARK: properties
    private let backgroundView = BasicBackgroundView()
    private lazy var contentView = makeContentView()
    private let onRulesSelected: (NonEmptyArray<RuleViewModel>) -> Void
    private let measurementSystem: MeasurementSystem

    // MARK: init
    internal init(
        measurementSystem: MeasurementSystem,
        onRulesSelected: @escaping (NonEmptyArray<RuleViewModel>) -> Void
    ) {
        self.measurementSystem = measurementSystem
        self.onRulesSelected = onRulesSelected

        super.init()

        self.title = NSLocalizedString("Add Existing Rules", comment: "")
    }

    // MARK: init helpers
    private func makeContentView() -> AddExistingRulesContentView {
        return AddExistingRulesContentView(
            rules: RulesController.shared.retrieve().allRules,
            system: measurementSystem,
            onRulesSelected: onRulesSelected,
            onNoRulesSelected: { [weak self] in
                self?.showNoRulesSelectedAlert()
            },
            configureEmptyView: { [weak self] emptyView in
                self?.setup(emptyView: emptyView)
            },
            configureFullView: { _ in }
        ).then {
            $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.contentView)
        }
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

    private func setup(emptyView: AddExistingRulesEmptyView) {
        emptyView.onGoBack = { [weak self] in
            self?.goBackButtonTapped()
        }
        emptyView.helpButton.addTarget(
            self,
            action: #selector(helpButtonTapped),
            for: .touchUpInside
        )
    }

    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Analytics.record(screen: .addExistingRules)
    }

    // MARK: showing alerts
    private func showNoRulesSelectedAlert() {
        let alert = AlertControllers.okAlert(
            withTitle: NSLocalizedString("No rules selected", comment: ""),
            message: NSLocalizedString("\nYou can select a rule by tapping them.", comment: "")
        )

        present(alert, animated: true)
    }

    // MARK: interface actions
    @objc
    private func goBackButtonTapped() {
        navController.popViewController(animated: true)
    }

    @objc
    private func helpButtonTapped() {
        present(AlertControllers.ruleInfoAlert(), animated: true)

        Analytics.record(event: .ruleGroupHelpButtonTapped)
    }

    // MARK: inset updates
    internal override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11, *) {
            contentView.update(bottomInset: view.safeAreaInsets.bottom)
        }
    }
}
