import ErrorRecorder
import RxSwift
import SnapKit
import Then
import UIKit
import WhatToWearCommonCore
import WhatToWearCore
import WhatToWearCoreComponents
import WhatToWearCoreUI
import WhatToWearModels

internal final class RootViewController: CodeBackedViewController, StatefulContainerViewController, NavStackEmbedded, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = RootViewController

        case mainView = "mainView"
    }

    // MARK: state
    internal enum State: ContainerViewControllerStateProtocol {
        case noLocationSelected(WelcomeViewController)
        case locationSelected(WeatherContainerViewController)

        // MARK: computed properties
        internal var viewController: UIViewController {
            switch self {
                case .noLocationSelected(let vc): return vc
                case .locationSelected(let vc): return vc
            }
        }
    }

    // MARK: properties
    internal lazy var state = makeInitialState(for: LocationController.shared.retrieve())
    internal var containerView: UIView {
        return view
    }
    private let disposeBag = DisposeBag()

    // MARK: status bar
    internal override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: setup
    private func setupObservers() {
        LocationController.shared.relay
            .asDriver()
            .distinctUntilChanged()
            .skip(1)
            .drive(onNext: { [weak self] storedLocations in
                guard let strongSelf = self else { return }
                
                let newState = strongSelf.makeInitialState(for: storedLocations)
                
                strongSelf.transition(to: newState)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()

        view.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.mainView)

        setupInitialViewController(state.viewController, containerView: containerView)
        setupNavigation()
        setupObservers()
    }

    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navController.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: making viewcontrollers
    private func makeWelcomeViewController() -> WelcomeViewController {
        return WelcomeViewController(onLocationSelection: { [weak self] selectedLocation in
            guard let strongSelf = self else { return }

            let storedLocations = StoredLocations(
                locations: NonEmptyArray(elements: selectedLocation),
                defaultLocation: selectedLocation
            )
            
            let locationsController = StoredLocationsController(storedLocations: storedLocations)
            
            LocationController.shared.save(storedLocations)

            Analytics.record(event: .locationSelected)
            
            strongSelf.dismissOurselves()
            
            strongSelf.transition(to: .locationSelected(
                WeatherContainerViewController(
                    locationsController: locationsController, recentlySelected: true
                )
            ))
        })
    }
    
    // MARK: making stats
    private func makeInitialState(for storedLocations: StoredLocations?) -> State {
        guard let storedLocations = storedLocations else {
            return .noLocationSelected(makeWelcomeViewController())
        }

        let locationsController = StoredLocationsController(storedLocations: storedLocations)
        
        return .locationSelected(WeatherContainerViewController(
            locationsController: locationsController, recentlySelected: false
        ))
    }
    
    // MARK: dismissing ourselves
    private func dismissOurselves() {
        switch InterfaceIdiom.current {
            case .phone:
                navController.popViewController(animated: false)
            case .pad:
                dismiss(animated: true)
        }
    }
}
