import Foundation
import WhatToWearCommonCore
import WhatToWearCommonModels
import WhatToWearCore
import WhatToWearModels

public struct RuleSectionViewModel: Hashable {
    public enum TimeInterval {
        case day
        case hourly(metHourlyDataPoints: NonEmptyArray<HourlyDataPoint>)
    }

    // MARK: properties
    public let title: String
    public let subtitle: String

    // MARK: init
    public init(rule: Rule, group: RuleGroup, forecast: Forecast, timeInterval: TimeInterval) {
        switch timeInterval {
            case .day:
                self.title = "\(rule.name) (\(group.name))"
                self.subtitle = ""
            case .hourly(metHourlyDataPoints: let metHourlyDataPoints):
                self.title = "\(rule.name) (\(group.name))"
                self.subtitle = Self.timeRangesString(
                    for: metHourlyDataPoints.map { $0.time },
                    timeZone: forecast.timeZone
                )
        }
    }

    public init(rule: Rule, forecast: Forecast, timeInterval: TimeInterval) {
        switch timeInterval {
            case .day:
                self.title = rule.name
                self.subtitle = ""
            case .hourly(metHourlyDataPoints: let metHourlyDataPoints):
                self.title = rule.name
                self.subtitle = Self.timeRangesString(
                    for: metHourlyDataPoints.map { $0.time },
                    timeZone: forecast.timeZone
                )
        }
    }

    // MARK: time ranges
    private static func timeRangesString(for times: NonEmptyArray<Date>, timeZone: TimeZone) -> String {
        let groups = group(times: times, timeZone: timeZone)

        let rangeStrings = groups.map { innerGroup -> String in
            let firstTime = innerGroup.first
            let lastTime = innerGroup.last

            if firstTime != lastTime {
                return timeRange(withStartDate: firstTime, endDate: lastTime, timeZone: timeZone)
            } else {
                return timeRange(withStartDate: firstTime, endDate: firstTime, timeZone: timeZone)
            }
        }

        return rangeStrings.oxfordCommaString
    }

    private static func timeRange(withStartDate startDate: Date, endDate: Date, timeZone: TimeZone) -> String {
        let dateFormatter = DateFormatters.shared.hourWithSpaceFormatter(for: timeZone)
        let endTime = addHours(1, to: endDate, timeZone: timeZone)

        return "\(dateFormatter.string(from: startDate))\(String.nbsp)\(String.nbhypen)\(String.nbsp)\(dateFormatter.string(from: endTime))"
    }

    // MARK: grouping
    private static func group(times: NonEmptyArray<Date>, timeZone: TimeZone) -> NonEmptyArray<NonEmptyArray<Date>> {
        let sortedTimes = times.sorted()

        var groups = NonEmptyArray(elements: NonEmptyArray(elements: sortedTimes.first))

        for time in sortedTimes.dropFirst() {
            let previousTime = addHours(-1, to: time, timeZone: timeZone)

            if let containingGroupIndex = groups.firstIndex(where: { $0.contains(previousTime) }) {
                let containingGroup = groups[containingGroupIndex]
                let newGroup = containingGroup.byAppending(time)

                groups[containingGroupIndex] = newGroup
            } else {
                groups.append(NonEmptyArray(elements: time))
            }
        }

        return groups
    }

    // MARK: incrementing dates
    private static func addHours(_ hours: Int, to date: Date, timeZone: TimeZone) -> Date {
        let calendar = Calendars.shared.calendar(for: timeZone)

        var oneHourComponent = DateComponents()
        oneHourComponent.hour = hours

        guard let endDate = calendar.date(byAdding: oneHourComponent, to: date) else {
            fatalError("Could not create date when adding components \(oneHourComponent) to date \(date)")
        }

        return endDate
    }
}
