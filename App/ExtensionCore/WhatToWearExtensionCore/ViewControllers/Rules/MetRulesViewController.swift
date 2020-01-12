import ErrorRecorder
import NotificationCenter
import UIKit
import WhatToWearCommonCore
import WhatToWearCore
import WhatToWearCoreComponents
import WhatToWearCoreUI

public final class MetRulesViewController: CodeBackedViewController, ExtensionConstantViewControllerProtocol, ContentSizeUpdater, MainAppLauncherProtocol {
    // MARK: properties
    private let reuseIdentifier = "ruleSectionCell"
    private let tableViewConfigurator = RuleTableViewConfigurator()
    private lazy var tableView = UITableView(frame: UIScreen.main.bounds).then {
        tableViewConfigurator.configure(tableView: $0)
        $0.register(RuleSectionTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        $0.dataSource = self
        $0.delegate = self
    }
    private lazy var headerView = self.makeHeaderView()
    private let prototypeCell = RuleSectionTableViewCell(style: .default, reuseIdentifier: "").then {
        $0.isHidden = true
    }
    private let rawViewModels: NonEmptyArray<RuleSectionViewModel>
    private let extensionType: ExtensionType
    private let onLoadComplete: ((NCUpdateResult) -> Void)?
    // swiftlint:disable implicitly_unwrapped_optional
    private var viewModels: NonEmptyArray<StaticHeightRuleVM>!
    private var totalHeight: CGFloat!
    // swiftlint:enable implicitly_unwrapped_optional

    public let setPreferredContentSize: (CGSize) -> Void

    // MARK: init
    public init(
        viewModels: NonEmptyArray<RuleSectionViewModel>,
        extensionType: ExtensionType,
        setPreferredContentSize: @escaping (CGSize) -> Void,
        onLoadComplete: ((NCUpdateResult) -> Void)?
    ) {
        self.rawViewModels = viewModels
        self.extensionType = extensionType
        self.setPreferredContentSize = setPreferredContentSize
        self.onLoadComplete = onLoadComplete

        super.init()
    }

    // MARK: setup
    private func setupViews() {
        view.add(subview: headerView, withConstraints: { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        })

        view.add(subview: tableView, withConstraints: { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        })
    }

    // MARK: UIViewController
    public override func viewDidLoad() {
        super.viewDidLoad()

        let usableWidth = view.frame.width - 16
        let bottomPadding: CGFloat = 10
        let headerHeight = headerView.heightForConstrainedWidth(usableWidth)
        self.viewModels = rawViewModels.map { vm in
            StaticHeightRuleVM(viewModel: vm, prototypeCell: prototypeCell, width: usableWidth)
        }

        self.totalHeight = viewModels.map { $0.cellHeight }.reduce(bottomPadding + headerHeight, +)

        setupViews()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Analytics.record(screen: .metRules(.todayExtension(extensionType.analyticsScreen)))

        onLoadComplete?(.newData)

        updatePreferredContentSize()
    }

    // MARK: making header views
    private func makeHeaderView() -> WhatToWearHeaderView {
        switch extensionType {
            case .rules, .forecast:
                // This screen isn't actually shown on forecasts
                return WhatToWearHeaderView(
                    config: .rulesOnly(onRulesButtonTap: { [weak self] in
                        self?.rulesbuttonTapped()
                    })
                )
            case .combined:
                return WhatToWearHeaderView(config: .noButtons)
        }
    }
    
    // MARK: interface actions
    @objc
    private func rulesbuttonTapped() {
        openRulesScreen(fromExtension: extensionType)
    }

    // MARK: widget
    public func preferredContentSize(for activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) -> CGSize {
        switch activeDisplayMode {
            case .compact:
                return maxSize
            case .expanded:
                return CGSize(
                    width: maxSize.width,
                    height: extensionType.expandedHeight(
                        forWidth: maxSize.width,
                        innerCalculatedHeight: .value(totalHeight)
                    )
                )
            @unknown default:
                fatalError("@unknown NCWidgetDisplayMode")
        }
    }
}

// MARK: UITableViewDelegate
extension MetRulesViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModels[indexPath.row].cellHeight
    }
}

// MARK: UITableViewDataSource
extension MetRulesViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RuleSectionTableViewCell = tableView.wtw_dequeueReusableCell(identifier: reuseIdentifier, indexPath: indexPath)
        cell.configure(with: viewModels[indexPath.row].innerViewModel)

        return cell
    }
}
