import Foundation

// MARK: PreComponentsGlobalSettings
public struct PreComponentsGlobalSettings: Codable {
    public let measurementSystem: MeasurementSystem

    public init(measurementSystem: MeasurementSystem) {
        self.measurementSystem = measurementSystem
    }
}
