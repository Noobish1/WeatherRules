import UIKit

public protocol NavStackEmbedded: UIViewController {
    var navController: UINavigationController { get }
}

extension NavStackEmbedded {
    // MARK: computed properties
    public var navController: UINavigationController {
        guard let navController = self.navigationController else {
            fatalError("\(self) should be embedded in a UINavigationController but is not")
        }

        return navController
    }

    // MARK: setup
    public func setupNavigation() {
        self.navigationItem.backBarButtonItem = .blank

        NavBarConfigurator.configure(navBar: navController.navigationBar)
    }
}
