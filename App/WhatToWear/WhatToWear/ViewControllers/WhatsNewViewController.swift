import ErrorRecorder
import UIKit
import WhatToWearCore
import WhatToWearCoreUI
import WhatToWearEnvironment
import WhatToWearModels

// MARK: WhatsNewViewController
internal final class WhatsNewViewController: CodeBackedViewController, NavStackEmbedded {
    // MARK: context
    internal enum Context {
        case settings
        case launch(onDismiss: () -> Void)
    }

    // MARK: properties
    private let backgroundView = BasicBackgroundView()
    private let cellReuseIdentifier = "whatsNewCell"
    private let headerReuseIdentifier = "whatsNewHeader"
    private lazy var contentView = WhatsNewContentView(
        context: context,
        onAppStoreButtonTapped: { [weak self] in
            self?.appStoreButtonTapped()
        }
    ).then {
        $0.tableView.dataSource = self
        $0.tableView.delegate = self
        $0.tableView.register(WhatsNewTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        $0.tableView.register(
            BasicSectionHeaderView.self,
            forHeaderFooterViewReuseIdentifier: headerReuseIdentifier
        )
    }
    private let context: Context
    private let viewModel = WhatsNewContentViewModel()

    // MARK: init
    internal init(context: Context) {
        self.context = context

        super.init()

        self.title = NSLocalizedString("What's New", comment: "")
    }

    // MARK: setup
    private func setupViews() {
        view.add(fullscreenSubview: backgroundView)

        view.add(subview: contentView, withConstraints: { make in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
            make.bottom.equalToSuperview()
        })
    }

    private func setupNavigation(for context: Context) {
        switch context {
            case .settings: setupNavigation()
            case .launch: break
        }
    }

    private func setupNavigationBar(for context: Context, animated: Bool) {
        switch context {
            case .settings:
                navController.setNavigationBarHidden(false, animated: animated)
            case .launch:
                break
        }
    }

    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupNavigation(for: context)
    }

    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigationBar(for: context, animated: animated)
    }

    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Analytics.record(screen: .whatsNew)
    }

    // MARK: interface actions
    @objc
    private func appStoreButtonTapped() {
        UIApplication.shared.open(Environment.Variables.AppStoreURL)

        Analytics.record(event: .viewFullVersionHistory)
    }

    // MARK: inset updates
    internal override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11, *) {
            contentView.update(bottomInset: view.safeAreaInsets.bottom)
        }
    }
}

// MARK: UITableViewDataSource
extension WhatsNewViewController: UITableViewDataSource {
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfUpdates
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfUpdateSections(forUpdate: section)
    }

    internal func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell: WhatsNewTableViewCell = tableView.wtw_dequeueReusableCell(
            identifier: cellReuseIdentifier, indexPath: indexPath
        )
        cell.configure(with: viewModel.updateSection(at: indexPath))

        return cell
    }
}

// MARK: UITableViewDelegate
extension WhatsNewViewController: UITableViewDelegate {
    internal func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let header: BasicSectionHeaderView = tableView.wtw_dequeueReusableHeaderFooterView(
            identifier: headerReuseIdentifier
        )
        header.configure(withTitle: viewModel.sectionHeaderTitle(forSection: section))

        return header
    }
}
