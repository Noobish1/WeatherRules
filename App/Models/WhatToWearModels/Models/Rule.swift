import Foundation
import WhatToWearCommonCore
import WhatToWearCommonModels

// MARK: Rule
public struct Rule: Codable, Equatable {
    private enum CodingKeys: String, CodingKey {
        case conditions = "conditions"
        // Backwards compatible
        case name = "clothingItem"
    }

    public let conditions: [Condition]
    public let name: String

    // MARK: init
    public init(conditions: [Condition], name: String) {
        self.conditions = conditions
        self.name = name
    }
}

// MARK: meeting
extension Rule {
    public func isMetBy(dataPoint: HourlyDataPoint, for forecast: Forecast) -> Bool {
        return conditions.all {
            $0.isMetBy(dataPoint: dataPoint, for: forecast)
        }
    }
}
