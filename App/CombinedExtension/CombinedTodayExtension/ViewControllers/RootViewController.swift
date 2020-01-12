import UIKit
import WhatToWearExtensionCore

// MARK: RootViewController
internal final class RootViewController: ExtensionRootViewController<ForecastLoadingViewController<CombinedPagingViewController>> {
    // MARK: init
    internal override init() {
        super.init(extensionType: .combined, makeInnerViewController: { params in
            ForecastLoadingViewController(params: params, makeInnerViewController: CombinedPagingViewController.init)
        })
    }
}
