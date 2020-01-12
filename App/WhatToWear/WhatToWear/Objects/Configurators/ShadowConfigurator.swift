import UIKit

internal enum ShadowConfigurator {
    // MARK: configuration
    internal static func configureTopShadow(for view: UIView) {
        view.layer.shadowOffset = CGSize(width: 1, height: -2)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 3
    }
}
