import UIKit
import WhatToWearAssets

extension UIBarButtonItem {
    public static var blank: UIBarButtonItem {
        return UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }

    public static func info(target: Any?, action: Selector?) -> UIBarButtonItem {
        return UIBarButtonItem(image: R.image.infoButton(), style: .plain, target: target, action: action)
    }
}
