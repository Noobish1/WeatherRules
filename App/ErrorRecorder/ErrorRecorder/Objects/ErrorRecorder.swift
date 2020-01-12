import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import Foundation
import WhatToWearEnvironment

public enum ErrorRecorder {
    // MARK: setup
    public static func setup() {
        if Environment.isCrashlyticsEnabled {
            MSAppCenter.start(Environment.Variables.AppCenterAPIKey, withServices: [
              MSAnalytics.self,
              MSCrashes.self
            ])
        }
    }

    // MARK: recording
    public static func record(_ error: WTWError) {
        if Environment.isDev {
            NSLog("NSError recorded: \(error)")
        }

        if Environment.isCrashlyticsEnabled {
            MSAnalytics.trackEvent(
                "Non-fatal - \(error.formatMD5)",
                withProperties: ["failureReason" : error.failureReason],
                flags: .critical
            )
        }
    }
}
