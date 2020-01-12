import Foundation
import NotificationCenter

// MARK: ExtensionConstantViewControllerProtocol
public protocol ExtensionConstantViewControllerProtocol: ExtensionViewControllerProtocol {}

// MARK: General extensions
extension ExtensionConstantViewControllerProtocol {
    public func performUpdate(completionHandler: @escaping ((NCUpdateResult) -> Void)) {
        // If this is called nothing has changed so return .noData
        completionHandler(.noData)
    }
}
