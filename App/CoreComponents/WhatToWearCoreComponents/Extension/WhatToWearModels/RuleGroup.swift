import Foundation
import WhatToWearCommonCore
import WhatToWearCommonModels
import WhatToWearCore
import WhatToWearModels

extension RuleGroup {
    internal func ruleSectionViewModels(for dataPoints: NonEmptyArray<HourlyDataPoint>, forecast: Forecast) -> [RuleSectionViewModel] {
        return self.preferredRulesToMetHourlyDataPoints(for: dataPoints.toArray(), for: forecast)
            .compactMap { tuple in
                let (rule, metHourlyDataPoints) = tuple

                return RuleSectionViewModel(
                    rule: rule,
                    group: self,
                    forecast: forecast,
                    timeInterval: .hourly(metHourlyDataPoints: metHourlyDataPoints)
                )
            }
    }
}
