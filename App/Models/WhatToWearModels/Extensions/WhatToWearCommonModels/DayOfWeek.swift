import Foundation
import WhatToWearCommonModels
import WhatToWearCore

// MARK: FiniteSetValueProtocol
extension DayOfWeek: FiniteSetValueProtocol {}

// MARK: SelectableValueProtocol
extension DayOfWeek: SelectableConditionValueProtocol {
    public static func specializedMeasurement(from wrapper: WeatherMeasurement) -> SelectableMeasurement<DayOfWeek>? {
        guard case .enumeration(.dayOfWeek(let measurement)) = wrapper else {
            return nil
        }

        return measurement
    }
}
