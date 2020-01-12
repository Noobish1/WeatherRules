import RxRelay
import WhatToWearCoreComponents
import WhatToWearExtensionCore

internal final class CombinedExtensionSettingsController: DefaultsBackedObservableControllerWithNonOptionalObject {
    // MARK: typealiases
    internal typealias Object = CombinedExtensionSettings

    // MARK: static properties
    internal static let shared = CombinedExtensionSettingsController()

    // MARK: properties
    internal let config: ControllerConfig
    internal let migrator: AnyMigrator<CombinedExtensionSettings>
    internal let relay: BehaviorRelay<CombinedExtensionSettings>

    // MARK: init
    private convenience init() {
        self.init(config: .combinedExtensionSettings, migrator: AnyMigrator(CombinedExtensionSettingsMigrator()))
    }

    internal init(config: ControllerConfig, migrator: AnyMigrator<CombinedExtensionSettings>) {
        self.config = config
        self.migrator = migrator
        self.relay = BehaviorRelay(value: Self.retrieve(config: config, migrator: migrator))
    }
}
