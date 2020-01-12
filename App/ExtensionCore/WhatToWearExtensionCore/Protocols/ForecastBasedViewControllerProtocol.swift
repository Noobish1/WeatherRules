import NotificationCenter
import UIKit
import WhatToWearModels

// MARK: ForecastBasedViewControllerProtocol
public protocol ForecastBasedViewControllerProtocol: UIViewController, ContentSizeDecider {
    func handleUnchangedForecast(
        _ timedForecast: TimedForecast,
        onComplete: ((NCUpdateResult) -> Void)?
    )
}
