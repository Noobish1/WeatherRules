import Foundation
import WhatToWearModels

internal enum RawDoubleMeasurementViewModel {
    // MARK: displayed strings
    internal static func displayedStringValueWithUnits(
        for measurement: RawDoubleMeasurement,
        rawValue: Double,
        system: MeasurementSystem
    ) -> String {
        return String(rawValue)
    }
}
