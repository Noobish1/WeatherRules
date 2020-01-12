import WhatToWearCoreComponents

extension ControllerConfig {
    internal static var combinedExtensionSettings: ControllerConfig {
        // We aren't sharing these settings so we just use standard UserDefaults
        
        return ControllerConfig(
            objectKey: "combinedExtensionSettings",
            objectVersionKey: "combinedExtensionSettingsVersion",
            defaults: .standard
        )
    }
}
