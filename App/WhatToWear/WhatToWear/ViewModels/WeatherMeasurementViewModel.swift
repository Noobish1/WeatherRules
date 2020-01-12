import Foundation
import WhatToWearCore
import WhatToWearModels

// MARK: WeatherMeasurementViewModel
internal struct WeatherMeasurementViewModel: Equatable {
    // MARK: properties
    private let system: MeasurementSystem

    internal let title: String
    internal let underlyingModel: WeatherMeasurement
    internal let explanation: String

    // MARK: init
    internal init(measurement: WeatherMeasurement, system: MeasurementSystem) {
        self.underlyingModel = measurement
        self.system = system
        self.explanation = measurement.explanation
        self.title = Self.title(for: measurement, system: system)
    }
    
    // MARK: static init helpers
    // swiftlint:disable cyclomatic_complexity
    internal static func title(for measurement: WeatherMeasurement, system: MeasurementSystem) -> String {
        switch measurement {
            case .double(let doubleMeasurement):
                switch doubleMeasurement {
                    case .percentage(let percentageMeasurement):
                        return PercentageMeasurementViewModel.title(for: percentageMeasurement)
                    case .calculatedPercentage(let calculatedPercentageMeasurement):
                        return CalculatedPercentageMeasurementViewModel.title(for: calculatedPercentageMeasurement)
                    case .temperature(let unitMeasurement):
                        return UnitMeasurementViewModel.title(for: unitMeasurement, system: system)
                    case .angle(let unitMeasurement):
                        return UnitMeasurementViewModel.title(for: unitMeasurement, system: system)
                    case .speed(let unitMeasurement):
                        return UnitMeasurementViewModel.title(for: unitMeasurement, system: system)
                    case .rawDouble(let rawDoubleMeasurement):
                        return rawDoubleMeasurement.name
                    case .length(let unitMeasurement):
                        return UnitMeasurementViewModel.title(for: unitMeasurement, system: system)
                    case .pressure(let unitMeasurement):
                        return UnitMeasurementViewModel.title(for: unitMeasurement, system: system)
            }
            case .enumeration(let enumMeasurement):
                return enumMeasurement.name
            case .time(let timeMeasurement):
                return timeMeasurement.name
        }
    }
    // swiftlint:enable cyclomatic_complexity
}
