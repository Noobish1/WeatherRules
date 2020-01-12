import ErrorRecorder
import Foundation
import RxRelay
import RxSwift
import WhatToWearCore
import WhatToWearModels

public final class LocationController: DefaultsBackedObservableControllerWithOptionalObject {
    // MARK: typealiases
    public typealias Object = StoredLocations
    // MARK: static properties
    public static let shared = LocationController()

    // MARK: instance properties
    public let relay: BehaviorRelay<StoredLocations?>
    public let migrator: AnyMigrator<StoredLocations>
    public let config: ControllerConfig

    // MARK: init
    private convenience init() {
        self.init(config: .locations, migrator: AnyMigrator(StoredLocationsMigrator()))
    }

    internal init(config: ControllerConfig, migrator: AnyMigrator<StoredLocations>) {
        self.config = config
        self.migrator = migrator
        self.relay = BehaviorRelay(value: Self.retrieve(config: config, migrator: migrator))
    }
}
