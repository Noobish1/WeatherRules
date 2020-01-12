import UIKit

public enum BorderConfigurator {
    // MARK: configuration
    public static func configureBorder(for view: UIView) {
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 6
    }
}
