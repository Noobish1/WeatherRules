import Foundation
import WhatToWearCommonCore
import WhatToWearCommonModels
import WhatToWearCore
import WhatToWearModels

public enum RulesState {
    case metRules(NonEmptyArray<RuleSectionViewModel>)
    case noRules(labelText: String)

    // MARK: init
    public init(
        storedRules: StoredRules,
        timedForecast: TimedForecast,
        timeSettings: TimeSettings
    ) {
        guard let nonEmptyStoredRules = NonEmptyStoredRules(storedRules: storedRules) else {
            self = .noRules(labelText: EmptyRulesState.noRules.displayedText)

            return
        }

        guard let finalViewModels = Self.finalViewModels(
            for: timeSettings,
            storedRules: nonEmptyStoredRules,
            timedForecast: timedForecast
        ) else {
            self = .noRules(labelText: EmptyRulesState.noMetRules.displayedText)

            return
        }

        self = .metRules(finalViewModels)
    }

    // MARK: init helpers
    public static func finalViewModels(
        for timeSettings: TimeSettings,
        storedRules: NonEmptyStoredRules,
        timedForecast: TimedForecast
    ) -> NonEmptyArray<RuleSectionViewModel>? {
        let vms = viewModels(
            for: timeSettings,
            storedRules: storedRules,
            forecast: timedForecast.forecast
        )

        let set = Set(vms)
        let finalArray = Array(set).sorted(by: \.title)
        
        return NonEmptyArray(array: finalArray)
    }

    private static func viewModels(
        for timeSettings: TimeSettings,
        storedRules: NonEmptyStoredRules,
        forecast: Forecast
    ) -> [RuleSectionViewModel] {
        let calendar = Calendars.shared.calendar(for: forecast.timeZone)

        let filteredHourlyDataPoints = forecast.hourly.data.toArray().filter { dataPoint in
            timeSettings.timeRange.contains(date: dataPoint.time, calendar: calendar)
        }

        guard let nonEmptyFilteredHourlyDataPoints = NonEmptyArray(array: filteredHourlyDataPoints) else {
            // If a user selects a time range that doesn't work it's their fault
            // i'll have to setup a minimum time range of an hour or two though
            return []
        }

        switch timeSettings.interval {
            case .hourly:
                return viewModelsForHourlyInterval(
                    storedRules: storedRules,
                    dataPoints: nonEmptyFilteredHourlyDataPoints,
                    forecast: forecast
                )
            case .fullDay:
                return viewModelsForFullDayInterval(
                    storedRules: storedRules,
                    dataPoints: nonEmptyFilteredHourlyDataPoints,
                    forecast: forecast
                )
        }
    }

    private static func viewModelsForFullDayInterval(
        storedRules: NonEmptyStoredRules,
        dataPoints: NonEmptyArray<HourlyDataPoint>,
        forecast: Forecast
    ) -> [RuleSectionViewModel] {
        let ruleGroups = storedRules.ruleGroups

        let groupViewModels = ruleGroups
            .compactMap { group -> (RuleGroup, Rule)? in
                guard
                    let rule = group.preferredRuleMetBy(dataPoints: dataPoints.toArray(), for: forecast)
                else {
                    return nil
                }

                return (group, rule)
            }
            .map { tuple -> RuleSectionViewModel in
                let (group, rule) = tuple

                return RuleSectionViewModel(
                    rule: rule,
                    group: group,
                    forecast: forecast,
                    timeInterval: .day
                )
            }

        let rulesViewModels = storedRules.ungroupedRules
            .filter { rule in
                dataPoints.any { rule.isMetBy(dataPoint: $0, for: forecast) }
            }
            .map { rule in
                RuleSectionViewModel(rule: rule, forecast: forecast, timeInterval: .day)
            }

        return groupViewModels + rulesViewModels
    }

    private static func viewModelsForHourlyInterval(
        storedRules: NonEmptyStoredRules,
        dataPoints: NonEmptyArray<HourlyDataPoint>,
        forecast: Forecast
    ) -> [RuleSectionViewModel] {
        let groupViewModels = storedRules.ruleGroups
            .map { $0.ruleSectionViewModels(for: dataPoints, forecast: forecast) }
            .flatMap { $0 }

        let rulesViewModels = storedRules.ungroupedRules
            .compactMap { rule -> (Rule, NonEmptyArray<HourlyDataPoint>)? in
                let metHourlyDataPoints = dataPoints.filter {
                    rule.isMetBy(dataPoint: $0, for: forecast)
                }

                guard let nonEmptyHourlyDataPoints = NonEmptyArray(array: metHourlyDataPoints) else {
                    return nil
                }

                return (rule, nonEmptyHourlyDataPoints)
            }
            .map { tuple -> RuleSectionViewModel in
                let (rule, metHourlyDataPoints) = tuple

                return RuleSectionViewModel(
                    rule: rule,
                    forecast: forecast,
                    timeInterval: .hourly(metHourlyDataPoints: metHourlyDataPoints)
                )
            }

        return groupViewModels + rulesViewModels
    }
}
