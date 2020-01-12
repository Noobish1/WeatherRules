import Foundation
import WhatToWearCommonCore
import WhatToWearCore
import WhatToWearCoreComponents
import WhatToWearCoreUI
import WhatToWearModels

// MARK: ChartConfigViewController
internal final class ChartConfigViewController: CodeBackedViewController, NavStackEmbedded {
    // MARK: properties
    private let backgroundView = BasicBackgroundView()
    private lazy var contentView = ChartConfigContentView(
        tableViewDataSource: self,
        onApply: { [weak self] in
            self?.applyButtonTapped()
        }
    )
    private let viewModel: ChartConfigViewModel
    private let onComplete: (GlobalSettings) -> Void

    // MARK: init/deinit
    internal init(settings: GlobalSettings, onComplete: @escaping (GlobalSettings) -> Void) {
        self.viewModel = ChartConfigViewModel(settings: settings)
        self.onComplete = onComplete
        
        super.init()

        self.title = NSLocalizedString("Chart Components", comment: "")
    }

    // MARK: setup
    private func setupViews() {
        view.add(fullscreenSubview: backgroundView)

        view.add(subview: contentView, withConstraints: { make in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        })
    }

    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupNavigation()

        contentView.preselect(indexPaths: viewModel.indexPathsForPreselecting)
    }

    // MARK: interface actions
    @objc
    private func applyButtonTapped() {
        let newSettings = viewModel.makeNewSettingsForSaving(fromSelectedIndexPaths: contentView.selectedIndexPaths)

        onComplete(newSettings)
    }

    // MARK: inset updates
    internal override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11, *) {
            contentView.update(bottomInset: view.safeAreaInsets.bottom)
        }
    }
}

// MARK: UITableViewDataSource
extension ChartConfigViewController: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfComponents
    }

    internal func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let componentVM = viewModel.componentViewModel(at: indexPath)

        let cell: MultiSelectTableViewCell = tableView.wtw_dequeueReusableCell(
            identifier: contentView.configCellReuseIdentifier,
            indexPath: indexPath
        )
        cell.configure(withText: componentVM.title)

        return cell
    }
}
