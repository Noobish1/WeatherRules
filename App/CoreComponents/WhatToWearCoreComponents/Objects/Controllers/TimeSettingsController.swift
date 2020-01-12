import ErrorRecorder
import Foundation
import RxRelay
import WhatToWearCore
import WhatToWearModels

public final class TimeSettingsController: DefaultsBackedObservableControllerWithNonOptionalObject {
    // MARK: typealiases
    public typealias Object = TimeSettings

    // MARK: static properties
    public static let shared = TimeSettingsController()

    // MARK: properties
    public let config: ControllerConfig
    public let migrator: AnyMigrator<TimeSettings>
    public let relay: BehaviorRelay<TimeSettings>

    // MARK: init
    private convenience init() {
        self.init(config: .timeSettings, migrator: AnyMigrator(TimeSettingsMigrator()))
    }

    internal init(config: ControllerConfig, migrator: AnyMigrator<TimeSettings>) {
        self.config = config
        self.migrator = migrator
        self.relay = BehaviorRelay(value: Self.retrieve(config: config, migrator: migrator))
    }
}
