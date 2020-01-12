import Foundation
import WhatToWearModels

extension GlobalSettings {
    // MARK: functions
    public func whatsNewState(recentlySelectedLocation: Bool) -> WhatsNewState {
        return WhatsNewState(settings: self, recentlySelectedLocation: recentlySelectedLocation)
    }
}
