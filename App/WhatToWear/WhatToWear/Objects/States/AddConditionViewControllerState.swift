import Foundation
import WhatToWearModels

internal enum AddConditionViewControllerState: Equatable {
    case empty
    case doubleMeasurement(DoubleMeasurement)
    case timeMeasurement(TimeMeasurement)
    case measurementSymbol(MeasurementSymbolPair)
    case condition(Condition)

    // MARK: computed properties
    internal var viewControllerTitle: String {
        switch self {
            case .empty:
                return NSLocalizedString("Add Condition", comment: "")
            case .doubleMeasurement, .timeMeasurement, .measurementSymbol, .condition:
                return NSLocalizedString("Edit Condition", comment: "")
        }
    }

    internal var addButtonTitle: String {
        switch self {
            case .empty:
                return NSLocalizedString("Add", comment: "")
            case .doubleMeasurement, .timeMeasurement, .measurementSymbol, .condition:
                return NSLocalizedString("Save", comment: "")
        }
    }

    internal var measurement: WeatherMeasurement? {
        switch self {
            case .empty: return nil
            case .doubleMeasurement(let measurement): return .double(measurement)
            case .timeMeasurement(let measurement): return .time(measurement)
            case .measurementSymbol(let pair): return pair.measurement
            case .condition(let condition): return condition.measurement
        }
    }

    // MARK: init
    internal init(afterSelectingMeasurement newMeasurement: WeatherMeasurement) {
        switch newMeasurement {
            case .double(let doubleMeasurement):
                self = .doubleMeasurement(doubleMeasurement)
            case .time(let timeMeasurement):
                self = .timeMeasurement(timeMeasurement)
            case .enumeration(let enumMeasurement):
                self = .measurementSymbol(.enumeration(
                    measurement: enumMeasurement,
                    symbol: enumMeasurement.symbol.singleSymbol
                ))
        }
    }

    // MARK: functions
    internal func measurementButtonState(
        for system: MeasurementSystem
    ) -> MeasurementButton.ButtonState {
        switch self {
            case .empty:
                return .noSelection
            case .doubleMeasurement(let measurement):
                return .selected(.double(measurement), system: system)
            case .timeMeasurement(let measurement):
                return .selected(.time(measurement), system: system)
            case .measurementSymbol(let pair):
                return .selected(pair.measurement, system: system)
            case .condition(let condition):
                return .selected(condition.measurement, system: system)
        }
    }
}
