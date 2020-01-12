import ErrorRecorder
import Then
import UIKit
import WhatToWearAssets
import WhatToWearCoreComponents
import WhatToWearCoreUI
import WhatToWearEnvironment

// MARK: AppDelegate
@UIApplicationMain
internal final class AppDelegate: UIResponder {
    // MARK: properties
    internal var window: UIWindow?
    internal var navigationController: UINavigationController?
    internal var rootViewController: RootViewController?
    
    // MARK: reseting state
    private func resetUserDefaults() {
        UserDefaults.resetAllSuites()

        guard let defaultsName = Bundle.main.bundleIdentifier else {
            fatalError("Our main bundle does not have a bundle identifier")
        }

        UserDefaults.standard.removePersistentDomain(forName: defaultsName)
    }

    private func validateAssets() {
        do {
            try R.validate()
        } catch let error {
            fatalError("Assets did not validate with error: \(error)")
        }
    }
}

// MARK: UIApplicationDelegate
extension AppDelegate: UIApplicationDelegate {
    internal func application(
        _ application: UIApplication,
        // swiftlint:disable discouraged_optional_collection
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
        // swiftlint:enable discouraged_optional_collection
    ) -> Bool {
        validateAssets()

        ErrorRecorder.setup()

        if CommandLine.arguments.contains(Constants.UITestingEnvironmentVariables.isUITesting) {
            resetUserDefaults()
        }

        let rootVC = RootViewController()
        rootVC.navigationItem.backBarButtonItem = .blank
        
        let navController = UINavigationController(rootViewController: rootVC)
        navController.navigationBar.barStyle = .black
        
        self.rootViewController = rootVC
        self.navigationController = navController
        self.window = UIWindow(frame: UIScreen.main.bounds).then {
            $0.rootViewController = navController
            $0.makeKeyAndVisible()
        }
        
        return true
    }
    
    internal func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        guard let deepLink = DeepLink(url: url) else {
            return false
        }
        
        return DeepLinkHandler.handleDeepLink(deepLink, rootViewController: rootViewController, navigationController: navigationController)
    }
}
