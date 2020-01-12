import Foundation

public enum UpdateWarningState: Equatable {
    case show(LatestAppUpdate)
    case hide

    public init(globalSettings: GlobalSettings, bundle: Bundle = .main) {
        guard
            let lastUpdate = globalSettings.lastUpdateAvailable,
            lastUpdate.isInstallable(for: bundle)
        else {
            self = .hide

            return
        }

        guard let lastSeenUpdate = globalSettings.lastSeenUpdate else {
            self = .show(lastUpdate)

            return
        }

        guard lastUpdate.version > lastSeenUpdate.version else {
            self = .hide

            return
        }

        self = .show(lastUpdate)
    }
}
