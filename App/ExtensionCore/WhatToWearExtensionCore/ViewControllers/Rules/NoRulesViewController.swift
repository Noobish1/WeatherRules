import ErrorRecorder
import NotificationCenter
import SnapKit
import Then
import UIKit
import WhatToWearCoreComponents
import WhatToWearCoreUI

public final class NoRulesViewController: CodeBackedViewController, ExtensionConstantViewControllerProtocol, MainAppLauncherProtocol {
    // MARK: properties
    private lazy var headerView = WhatToWearHeaderView(
        config: .rulesOnly(onRulesButtonTap: { [weak self] in
            self?.rulesbuttonTapped()
        })
    )
    private lazy var label = UILabel().then {
        $0.text = labelText
        $0.textColor = .white
        $0.textAlignment = .center
    }
    private let labelText: String
    private let extensionType: ExtensionType
    private let onLoadComplete: ((NCUpdateResult) -> Void)?

    // MARK: init
    public init(
        state: EmptyRulesState,
        extensionType: ExtensionType,
        onLoadComplete: ((NCUpdateResult) -> Void)?
    ) {
        self.labelText = state.displayedText
        self.extensionType = extensionType
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

        view.add(subview: label, withConstraints: { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        })
    }

    // MARK: UIViewController
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

        onLoadComplete?(.newData)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Analytics.record(screen: .noRules(extensionType.analyticsScreen))
    }

    // MARK: interface actions
    @objc
    private func rulesbuttonTapped() {
        openRulesScreen(fromExtension: extensionType)
    }

    // MARK: widget
    public func preferredContentSize(
        for activeDisplayMode: NCWidgetDisplayMode,
        withMaximumSize maxSize: CGSize
    ) -> CGSize {
        switch activeDisplayMode {
            case .compact: return maxSize
            case .expanded:
                return CGSize(
                    width: maxSize.width,
                    height: extensionType.expandedHeight(
                        forWidth: maxSize.width, innerCalculatedHeight: .noneCalculated
                    )
                )
            @unknown default:
                fatalError("@unknown NCWidgetDisplayMode")
        }
    }
}
