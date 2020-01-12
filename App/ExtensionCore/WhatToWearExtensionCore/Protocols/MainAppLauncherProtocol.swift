import ErrorRecorder
import Foundation
import WhatToWearCore
import WhatToWearCoreComponents
import WhatToWearEnvironment

// MARK: MainAppLauncherProtocol
public protocol MainAppLauncherProtocol: UIViewController {}

// MARK: Extensions
extension MainAppLauncherProtocol {
    public func openLegendScreen(fromExtension extensionType: ExtensionType) {
        openDeepLink(.legend, fromExtension: extensionType)
    }
    
    public func openRulesScreen(fromExtension extensionType: ExtensionType) {
        openDeepLink(.rules, fromExtension: extensionType)
    }
    
    public func openMainApp(fromExtension extensionType: ExtensionType) {
        openDeepLink(.mainApp, fromExtension: extensionType)
    }
    
    private func openDeepLink(_ deepLink: DeepLink, fromExtension extensionType: ExtensionType) {
        guard let extensionContext = self.extensionContext else {
            fatalError("No extension context when opening deep link \(deepLink)")
        }
        
        extensionContext.open(deepLink.url.url, completionHandler: { succeeded in
            if succeeded {
                Analytics.record(event: deepLink.analyticsEvent(for: extensionType.analyticsScreen))
            } else {
                let ourError = WTWError(format: "\(self) failed to open main app for url: \(deepLink.url.url)", arguments: [])
                
                ErrorRecorder.record(ourError)
            }
        })
    }
}
