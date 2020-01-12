import ErrorRecorder
import NotificationCenter
import UIKit
import WhatToWearCoreUI
import WhatToWearExtensionCore

// MARK: RootViewController
internal final class RootViewController: ExtensionRootViewController<RulesContainerViewController> {
    // MARK: init
    internal override init() {
        super.init(extensionType: .rules, makeInnerViewController: RulesContainerViewController.init)
    }
}
