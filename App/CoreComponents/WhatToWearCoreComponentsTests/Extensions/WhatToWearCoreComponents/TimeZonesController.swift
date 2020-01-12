@testable import WhatToWearCoreComponents

extension TimeZonesController {
    internal static func random(defaults: UserDefaults) -> TimeZonesController {
        return TimeZonesController(
            config: ControllerConfig.random(defaults: defaults),
            migrator: AnyMigrator(TimeZoneStoreMigrator())
        )
    }
}
