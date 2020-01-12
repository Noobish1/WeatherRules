import Foundation

public struct DisplayedValue {
    // MARK: properties
    public let value: Double
    internal let system: MeasurementSystem

    // MARK: init
    public init(value: Double, system: MeasurementSystem) {
        self.value = value
        self.system = system
    }
}
