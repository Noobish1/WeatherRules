import Foundation
import WhatToWearCommonCore
import WhatToWearCommonModels
import WhatToWearCore

// MARK: RuleGroup
public struct RuleGroup: Codable, Equatable {
    public let name: String
    public let rules: [Rule]

    public init(name: String, rules: [Rule]) {
        self.name = name
        self.rules = rules
    }
}

// MARK: meeting
extension RuleGroup {
    // MARK: meeting multiple datapoints
    public func preferredRuleMetBy(dataPoints: [HourlyDataPoint], for forecast: Forecast) -> Rule? {
        return rules.first(where: { rule in
            dataPoints.any { dataPoint in
                rule.isMetBy(dataPoint: dataPoint, for: forecast)
            }
        })
    }

    // MARK: Meeting single datapoints
    public func isMetBy(dataPoint: HourlyDataPoint, for forecast: Forecast) -> Bool {
        return rules.any { $0.isMetBy(dataPoint: dataPoint, for: forecast) }
    }

    public func preferredRuleMetBy(dataPoint: HourlyDataPoint, for forecast: Forecast) -> Rule? {
        return rules.first(where: { $0.isMetBy(dataPoint: dataPoint, for: forecast) })
    }

    public func preferredRulesToMetHourlyDataPoints(for dataPoints: [HourlyDataPoint], for forecast: Forecast) -> [(Rule, NonEmptyArray<HourlyDataPoint>)] {
        let prefferedRulesToHourlyDataPoints = dataPoints.compactMap { dataPoint -> (Rule, HourlyDataPoint)? in
            guard let rule = preferredRuleMetBy(dataPoint: dataPoint, for: forecast) else {
                return nil
            }

            return (rule, dataPoint)
        }

        var result: [(Rule, NonEmptyArray<HourlyDataPoint>)] = []

        for rule in prefferedRulesToHourlyDataPoints.map({ $0.0 }) {
            let matchingPoints = prefferedRulesToHourlyDataPoints.filter { $0.0 == rule }.map { $0.1 }

            guard let nonEmptyPoints = NonEmptyArray(array: matchingPoints) else {
                continue
            }

            result.append((rule, nonEmptyPoints))
        }

        return result
    }
}
