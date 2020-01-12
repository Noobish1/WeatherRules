import UIKit
import WhatToWearCoreComponents
import WhatToWearCoreUI

internal enum DeepLinkHandler {
    // MARK: handling
    internal static func handleDeepLink(
        _ deepLink: DeepLink, rootViewController: RootViewController?, navigationController: UINavigationController?
    ) -> Bool {
        if case .mainApp = deepLink {
            return true
        }
        
        guard let rootViewController = rootViewController, let navController = navigationController else {
            return false
        }
        
        guard rootViewControllerIsInSafeStateForDeepLinking(rootViewController: rootViewController) else {
            return false
        }
        
        navController.popToRootViewController(animated: false)
        
        if navController.presentedViewController != nil {
            navController.dismiss(animated: false)
        }
        
        switch deepLink {
            case .mainApp:
                return true
            case .rules:
                presentRulesViewController(from: navController)
            case .legend:
                presentLegendViewController(from: navController)
        }
        
        return true
    }
    
    // MARK: checks
    private static func rootViewControllerIsInSafeStateForDeepLinking(rootViewController: RootViewController) -> Bool {
        switch rootViewController.state {
            case .noLocationSelected: return false
            case .locationSelected(let vc):
                switch vc.state {
                    case .phoneWhatsNew, .padWhatsNew: return false
                    case .noWhatsNew(let loadedState):
                        switch loadedState {
                            case .errored, .loading: return false
                            case .loaded: return true
                        }
                }
        }
    }
    
    // MARK: presenting
    private static func presentRulesViewController(from presenter: UINavigationController) {
        let vc = RulesViewController()
        
        switch InterfaceIdiom.current {
            case .phone:
                presenter.pushViewController(vc, animated: false)
            case .pad:
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .formSheet
            
                presenter.present(navVC, animated: false)
        }
    }
    
    private static func presentLegendViewController(from presenter: UINavigationController) {
        let settings = GlobalSettingsController.shared.retrieve()
        let vc = LegendViewController(settings: settings)

        switch InterfaceIdiom.current {
            case .phone:
                presenter.pushViewController(vc, animated: false)
            case .pad:
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .formSheet
            
                presenter.present(navVC, animated: false)
        }
    }
}
