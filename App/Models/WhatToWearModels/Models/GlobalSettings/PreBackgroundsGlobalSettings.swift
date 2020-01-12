import Foundation

// MARK: PreBackgroundsGlobalSettings
public struct PreBackgroundsGlobalSettings: Codable, Equatable {
    // MARK: properties
    public let measurementSystem: MeasurementSystem
    public let shownComponents: [WeatherChartComponent: Bool]

    // MARK: init
    public init(
        measurementSystem: MeasurementSystem,
        shownComponents: [WeatherChartComponent: Bool]
    ) {
        self.measurementSystem = measurementSystem
        self.shownComponents = shownComponents
    }
}
