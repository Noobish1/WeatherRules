import Foundation
import WhatToWearCore
import WhatToWearModels

// We need this extension because the WhatsNewContentViewModel is in the WhatToWear target
extension WhatsNewState {
    internal init(
        settings: GlobalSettings,
        appVersion: OperatingSystemVersion = Bundle.main.version,
        content: WhatsNewContentViewModel = WhatsNewContentViewModel(),
        recentlySelectedLocation: Bool
    ) {
        guard settings.whatsNewOnLaunch && !recentlySelectedLocation else {
            self = .hideWhatsNew(updateSettings: true)
            
            return
        }

        let lastSeenVersion = settings.lastWhatsNewVersionSeen
        let hasWhatsNewContentToShow = content.hasUpdate(matching: appVersion)

        if appVersion > lastSeenVersion && hasWhatsNewContentToShow {
            self = .showWhatsNew
        } else {
            self = .hideWhatsNew(updateSettings: false)
        }
    }
}
