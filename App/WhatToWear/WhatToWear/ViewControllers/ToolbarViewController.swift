import ErrorRecorder
import RxSwift
import Then
import UIKit
import WhatToWearCoreComponents
import WhatToWearCoreUI
import WhatToWearModels

internal final class ToolbarViewController: CodeBackedViewController, Accessible, NavStackEmbedded {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = ToolbarViewController

        case toolbarView = "toolbarView"
        case mainView = "mainView"
    }

    // MARK: properties
    private lazy var editLongPressRecognizer = UILongPressGestureRecognizer(
        target: self, action: #selector(editLocationLongPressed)
    )
    
    private let bottomAnchoredTransitioner = BottomAnchoredTransitioner()
    private let toolbarView: ToolbarView
    private let disposeBag = DisposeBag()
    private let locationsController: StoredLocationsController

    // MARK: init
    internal init(
        timedForecast: TimedForecast,
        locationsController: StoredLocationsController
    ) {
        self.toolbarView = ToolbarView(
            timeSettings: TimeSettingsController.shared.retrieve(),
            timedForecast: timedForecast,
            globalSettings: GlobalSettingsController.shared.retrieve()
        )

        self.locationsController = locationsController
        
        super.init()
    }

    // MARK: setup
    private func setupViews() {
        view.add(fullscreenSubview: toolbarView)

        setupToolbarView()
    }

    private func setupToolbarView() {
        toolbarView.editLocationButton.addTarget(
            self, action: #selector(editLocationButtonTapped), for: .touchUpInside
        )
        toolbarView.editLocationButton.addGestureRecognizer(editLongPressRecognizer)
        
        toolbarView.timeSettingsButton.addTarget(
            self, action: #selector(timeSettingsButtonTapped), for: .touchUpInside
        )
        toolbarView.settingsButton.addTarget(
            self, action: #selector(settingsButtonTapped), for: .touchUpInside
        )
        toolbarView.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.toolbarView)
    }

    private func setupObservers() {
        GlobalSettingsController.shared.relay
            .asDriver()
            .distinctUntilChanged()
            .skip(1)
            .drive(onNext: { [toolbarView] settings in
                toolbarView.update(globalSettings: settings)
            })
            .disposed(by: disposeBag)
        
        TimeSettingsController.shared.relay
            .asDriver()
            .distinctUntilChanged()
            .skip(1)
            .drive(onNext: { [toolbarView] settings in
                toolbarView.update(timeSettings: settings)
            })
            .disposed(by: disposeBag)
    }

    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()

        view.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.mainView)

        setupViews()
        setupObservers()
    }

    // MARK: interface actions
    @objc
    private func timeSettingsButtonTapped() {
        let vc = TimeSettingsViewController()
        
        presentBottomAnchoredOrPopover(viewController: vc, from: toolbarView)
    }

    @objc
    private func settingsButtonTapped() {
        presentNavDependent(viewController: SettingsViewController())
    }
    
    @objc
    private func editLocationLongPressed(recognizer: UILongPressGestureRecognizer) {
        guard case .began = recognizer.state else {
            return
        }
        
        recognizer.reset()
        
        let vc = SwitchLocationViewController(
            locationsController: locationsController,
            onDone: { [weak self] in
                self?.dismiss(animated: true)
            }
        )
        
        presentBottomAnchoredOrPopover(viewController: vc, from: toolbarView.editLocationButton)
    }
    
    @objc
    private func editLocationButtonTapped() {
        let vc = LocationsViewController(locationsController: locationsController)
        
        presentNavDependent(viewController: vc)
    }
    
    // MARK: presenting
    private func presentBottomAnchoredOrPopover(
        viewController innerVC: BottomAnchoredInnerViewControllerProtocol,
        from view: UIView
    ) {
        let vc = BottomAnchoredContainerViewController(
            innerViewController: innerVC
        )
        
        switch InterfaceIdiom.current {
            case .phone:
                vc.transitioningDelegate = bottomAnchoredTransitioner
                vc.modalPresentationStyle = .custom
                
                present(vc, animated: true)
            case .pad:
                vc.modalPresentationStyle = .popover
                vc.popoverPresentationController?.sourceView = view
                vc.popoverPresentationController?.sourceRect = CGRect(
                    origin: CGPoint(x: view.bounds.midX, y: 0), size: .zero
                )
            
                present(vc, animated: true)
        }
    }
    
    private func presentNavDependent(viewController: UIViewController) {
        switch InterfaceIdiom.current {
            case .phone:
                navController.pushViewController(viewController, animated: true)
            case .pad:
                let navVC = UINavigationController(rootViewController: viewController)
                navVC.modalPresentationStyle = .formSheet
            
                present(navVC, animated: true)
        }
    }
}
