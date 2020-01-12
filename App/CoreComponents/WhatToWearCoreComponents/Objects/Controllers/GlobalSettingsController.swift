import ErrorRecorder
import Foundation
import RxRelay
import WhatToWearCore
import WhatToWearModels

public final class GlobalSettingsController: DefaultsBackedObservableControllerWithNonOptionalObject {
    // MARK: typealias
    public typealias Object = GlobalSettings

    // MARK: static properties
    public static let shared = GlobalSettingsController()

    // MARK: instance properties
    public let config: ControllerConfig
    public let migrator: AnyMigrator<Object>
    public let relay: BehaviorRelay<GlobalSettings>

    private(set) public var lastAppLookupDate: Date?

    // MARK: init
    private convenience init() {
        self.init(config: .globalSettings, migrator: AnyMigrator(GlobalSettingsMigrator()))
    }

    internal init(config: ControllerConfig, migrator: AnyMigrator<GlobalSettings>) {
        self.config = config
        self.migrator = migrator
        self.relay = BehaviorRelay(value: Self.retrieve(config: config, migrator: migrator))
    }

    // MARK: update
    public func update(with latestAppUpdate: LatestAppUpdate?) {
        lastAppLookupDate = Date.now

        let oldSettings = retrieve()
        let newSettings = oldSettings.with(\.lastUpdateAvailable, value: latestAppUpdate)

        save(newSettings)
    }
    
    public func updateAndSaveSetting<T>(
        withNewValue newValue: T,
        for keyPath: WritableKeyPath<GlobalSettings, T>
    ) -> Object {
        let oldSettings = retrieve()
        let newSettings = oldSettings.with(keyPath, value: newValue)
        
        save(newSettings)
        
        return newSettings
    }
}
