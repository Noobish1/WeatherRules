import ErrorRecorder
import NotificationCenter
import SnapKit
import Then
import UIKit
import WhatToWearCore
import WhatToWearCoreUI

public final class NoLocationViewController: CodeBackedViewController, ExtensionConstantViewControllerProtocol, MainAppLauncherProtocol {
    // MARK: properties
    private let containerView = UIView()
    private let label = UILabel().then {
        $0.text = NSLocalizedString("No location set.", comment: "")
        $0.textColor = .white
    }
    private lazy var button = BorderedInsetButton(
        onTap: { [weak self] in
            guard let strongSelf = self else { return }

            strongSelf.openMainApp(fromExtension: strongSelf.extensionType)
        }
    ).then {
        $0.label.text = NSLocalizedString("Set one", comment: "")
    }
    private let extensionType: ExtensionType
    private let onLoadComplete: ((NCUpdateResult) -> Void)?

    // MARK: init
    internal init(params: LocationContainerParams) {
        self.extensionType = params.extensionType
        self.onLoadComplete = params.onLoadComplete

        super.init()
    }

    // MARK: setup
    private func setupViews() {
        view.add(
            subview: containerView,
            withConstraints: { make in
                make.center.equalToSuperview()
            },
            subviews: { container in
                container.add(subview: label, withConstraints: { make in
                    make.top.equalToSuperview()
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                })

                container.add(subview: button, withConstraints: { make in
                    make.top.equalTo(label.snp.bottom).offset(10)
                    make.centerX.equalToSuperview()
                    make.bottom.equalToSuperview()
                })
            }
        )
    }

    // MARK: UIViewController
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

        onLoadComplete?(.newData)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Analytics.record(screen: .noLocation(extensionType.analyticsScreen))
    }

    // MARK: widget sizing
    public func preferredContentSize(
        for activeDisplayMode: NCWidgetDisplayMode,
        withMaximumSize maxSize: CGSize
    ) -> CGSize {
        // Custom implementation because we have specific heights we want
        switch activeDisplayMode {
            case .compact:
                return CGSize(width: maxSize.width, height: 160)
            case .expanded:
                return CGSize(
                    width: maxSize.width,
                    height: extensionType.expandedHeight(forWidth: maxSize.width, innerCalculatedHeight: .noneCalculated)
                )
            @unknown default:
                fatalError("@unknown NCWidgetDisplayMode")
        }
    }
}
