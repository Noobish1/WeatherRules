import Foundation
import WhatToWearCommonModels
import WhatToWearCore

// MARK: DoubleMeasurement
public enum DoubleMeasurement: Equatable {
    case percentage(PercentageMeasurement)
    case calculatedPercentage(CalculatedPercentageMeasurement)
    case temperature(UnitMeasurement<UnitTemperature>)
    case angle(UnitMeasurement<UnitAngle>)
    case speed(UnitMeasurement<UnitSpeed>)
    case rawDouble(RawDoubleMeasurement)
    case length(UnitMeasurement<UnitLength>)
    case pressure(UnitMeasurement<UnitPressure>)
}

// MARK: BasicDoubleMeasurementProtocol
extension DoubleMeasurement: BasicDoubleMeasurementProtocol {
    // MARK: computed properties
    private var wrapper: BasicDoubleMeasurementProtocol {
        switch self {
            case .percentage(let measurement): return measurement
            case .calculatedPercentage(let measurement): return measurement
            case .temperature(let measurement): return measurement
            case .angle(let measurement): return measurement
            case .speed(let measurement): return measurement
            case .rawDouble(let measurement): return measurement
            case .length(let measurement): return measurement
            case .pressure(let measurement): return measurement
        }
    }

    // MARK: functions
    public var rawRange: ClosedRange<Double> {
        return wrapper.rawRange
    }

    public func rawValue(forDisplayedValue displayedValue: DisplayedValue) -> Double {
        return wrapper.rawValue(forDisplayedValue: displayedValue)
    }

    public func value(for dataPoint: HourlyDataPoint, in forecast: Forecast) -> Double? {
        return wrapper.value(for: dataPoint, in: forecast)
    }
}

// MARK: BasicMeasurementProtocol
extension DoubleMeasurement: BasicMeasurementProtocol {
    // MARK: computed properties
    public var id: MeasurementID {
        return wrapper.id
    }

    public var name: String {
        return wrapper.name
    }

    public var basicValue: BasicMeasurementValue {
        return wrapper.basicValue
    }

    public var explanation: String {
        return wrapper.explanation
    }
}
