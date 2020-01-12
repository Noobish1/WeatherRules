import Foundation
import WhatToWearCommonModels
import WhatToWearModels

internal struct ValidChartValue<T> {
    internal let time: Date
    internal let value: T

    internal init?(data: HourlyDataPoint, keyPath: KeyPath<HourlyDataPoint, T?>) {
        guard let value = data[keyPath: keyPath] else {
            return nil
        }

        self.time = data.time
        self.value = value
    }
}
