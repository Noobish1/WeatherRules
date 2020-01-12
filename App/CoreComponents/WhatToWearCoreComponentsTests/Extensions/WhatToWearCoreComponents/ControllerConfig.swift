@testable import WhatToWearCoreComponents

extension ControllerConfig {
    internal static func random(defaults: UserDefaults) -> ControllerConfig {
        return ControllerConfig(
            objectKey: String.wtw.random(),
            objectVersionKey: String.wtw.random(),
            defaults: defaults
        )
    }
}
