import Foundation
import WhatToWearCommonModels
import WhatToWearCore

// MARK: FiniteSetValueProtocol
extension WindDirection: FiniteSetValueProtocol {}

// MARK: SelectableValueProtocol
extension WindDirection: SelectableConditionValueProtocol {
    public static func specializedMeasurement(from wrapper: WeatherMeasurement) -> SelectableMeasurement<Self>? {
        guard case .enumeration(.windDirection(let measurement)) = wrapper else {
            return nil
        }
        
        return measurement
    }
}
