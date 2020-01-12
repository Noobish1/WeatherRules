import UIKit

public enum NavBarConfigurator {
    public static func configure(navBar: UINavigationBar) {
        navBar.setBackgroundImage(UIImage(color: .clear), for: .default)
        navBar.shadowImage = nil
        navBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBar.tintColor = .white
        navBar.barStyle = .black
    }
}
