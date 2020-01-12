@testable import WhatToWearCoreComponents

extension ForecastController {
    internal static func random(
        config: ControllerConfig,
        timeZonesController: TimeZonesController = .init(),
        migrator: AnyMigrator<ForecastStore> = AnyMigrator(ForecastStoreMigrator())
    ) -> ForecastController {
        return ForecastController(
            config: config,
            timeZonesController: timeZonesController,
            migrator: migrator
        )
    }
}
