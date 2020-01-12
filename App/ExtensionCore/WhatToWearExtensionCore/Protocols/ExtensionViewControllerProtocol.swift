import Foundation
import NotificationCenter

// MARK: ExtensionViewControllerProtocol
public protocol ExtensionViewControllerProtocol: UIViewController, ContentSizeDecider {
    func performUpdate(completionHandler: @escaping (NCUpdateResult) -> Void)
}
