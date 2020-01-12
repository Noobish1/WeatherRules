import Foundation
import WhatToWearCore

public protocol SelectableConditionValueProtocol: FiniteSetValueProtocol {
    static func specializedMeasurement(from wrapper: WeatherMeasurement) -> SelectableMeasurement<Self>?
}
