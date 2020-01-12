import ErrorRecorder
import NotificationCenter
import UIKit
import WhatToWearCoreUI
import WhatToWearExtensionCore

// MARK: RootViewController
internal final class RootViewController: ExtensionRootViewController<ForecastLoadingViewController<TodayViewController>> {
    // MARK: init
    internal override init() {
        super.init(extensionType: .forecast, makeInnerViewController: { params in
            ForecastLoadingViewController(params: params, makeInnerViewController: TodayViewController.init)
        })
    }
}
