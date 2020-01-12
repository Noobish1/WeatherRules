import UIKit
import WhatToWearCore

// MARK: General extensions
extension UIApplication {
    internal func openSettings() {
        let url = HardCodedURL(UIApplication.openSettingsURLString)

        UIApplication.shared.open(url)
    }

    internal func open(
        _ url: HardCodedURL,
        options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:],
        completionHandler completion: ((Bool) -> Void)? = nil
    ) {
        open(url.url, options: options, completionHandler: completion)
    }
}
