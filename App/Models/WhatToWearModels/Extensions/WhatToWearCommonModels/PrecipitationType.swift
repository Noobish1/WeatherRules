import Foundation
import WhatToWearCommonModels
import WhatToWearCore

// MARK: FiniteSetValueProtocol
extension PrecipitationType: FiniteSetValueProtocol {}

// MARK: SelectableValueProtocol
extension PrecipitationType: SelectableConditionValueProtocol {
    public static func specializedMeasurement(from wrapper: WeatherMeasurement) -> SelectableMeasurement<PrecipitationType>? {
        guard case .enumeration(.precipType(let measurement)) = wrapper else {
            return nil
        }

        return measurement
    }
}
