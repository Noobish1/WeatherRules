import Foundation
import WhatToWearCommonModels
import WhatToWearCore

// MARK: DoubleCondition
public struct TimeCondition: ConditionProtocol, Equatable, Withable {
    // MARK: properties
    public let measurement: TimeMeasurement
    public var symbol: TimeSymbol
    public var value: TimeRange

    // MARK: init
    public init(measurement: TimeMeasurement, symbol: TimeSymbol, value: TimeRange) {
        self.measurement = measurement
        self.symbol = symbol
        self.value = value
    }

    // MARK: static functions
    public static func specializedMeasurement(from wrapper: WeatherMeasurement) -> TimeMeasurement? {
        guard case .time(let measurement) = wrapper else {
            return nil
        }

        return measurement
    }

    public static func specializedSymbol(
        from container: KeyedDecodingContainer<ConditionProtocolCodingKeys>
    ) throws -> TimeSymbol {
        // We have a default value for this because we used to not save the symbol
        // because it was always the same, turns out that's a bad idea past self
        return (try? container.decode(TimeSymbol.self, forKey: .symbol)) ?? .between
    }

    // MARK: instance functions
    public func isMetBy(dataPoint: HourlyDataPoint, for forecast: Forecast) -> Bool {
        switch symbol {
            case .between, .before, .after:
                let calendar = Calendars.shared.calendar(for: forecast.timeZone)

                guard let dataPointValue = measurement.value.retrieve(from: dataPoint, forecast: forecast) else {
                    return false
                }

                return value.contains(date: dataPointValue, calendar: calendar)
        }
    }

    public func encodeSymbol(
        in container: inout KeyedEncodingContainer<ConditionProtocolCodingKeys>
    ) throws {
        try container.encode(symbol, forKey: .symbol)
    }
}
