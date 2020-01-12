import ErrorRecorder
import Foundation
import NotificationCenter
import SnapKit
import WhatToWearCoreUI
import WhatToWearModels

public protocol ForecastDisplayerViewControllerProtocol: ContentSizeUpdater, ForecastBasedViewControllerProtocol {
    var initialParams: ForecastLoadingParams { get }
}

extension ForecastDisplayerViewControllerProtocol {
    // MARK: computed properties
    public var setPreferredContentSize: (CGSize) -> Void {
        return initialParams.setPreferredContentSize
    }
    
    // MARK: when appearing
    public func onAppear() {
        Analytics.record(screen: .today(initialParams.extensionType.analyticsScreen))
        
        initialParams.onLoadComplete?(.newData)
        
        updatePreferredContentSize()
    }
    
    // MARK: ForecastBasedViewControllerProtocol
    public func handleUnchangedForecast(
        _ forecast: TimedForecast,
        onComplete: ((NCUpdateResult) -> Void)?
    ) {
        // do nothing
        onComplete?(.noData)
    }
    
    // MARK: ContentSizeDecider
    public func preferredContentSize(
        for activeDisplayMode: NCWidgetDisplayMode,
        withMaximumSize maxSize: CGSize
    ) -> CGSize {
        switch activeDisplayMode {
            case .compact:
                return maxSize
            case .expanded:
                return CGSize(
                    width: maxSize.width,
                    height: initialParams.extensionType.expandedHeight(
                        forWidth: maxSize.width, innerCalculatedHeight: .noneCalculated
                    )
                )
            @unknown default:
                fatalError("@unknown NCWidgetDisplayMode")
        }
    }
}
