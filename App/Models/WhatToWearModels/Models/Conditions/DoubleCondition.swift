import Foundation
import WhatToWearCommonModels
import WhatToWearCore

// MARK: DoubleCondition
public struct DoubleCondition: ConditionProtocol, Equatable, Withable {
    // MARK: properties
    public let measurement: DoubleMeasurement
    public var symbol: DoubleSymbol
    public var value: Double

    // MARK: init
    public init(measurement: DoubleMeasurement, symbol: DoubleSymbol, value: Double) {
        self.measurement = measurement
        self.symbol = symbol
        self.value = value
    }

    // MARK: static functions
    public static func specializedMeasurement(from wrapper: WeatherMeasurement) -> DoubleMeasurement? {
        guard case .double(let measurement) = wrapper else {
            return nil
        }

        return measurement
    }

    public static func specializedSymbol(
        from container: KeyedDecodingContainer<ConditionProtocolCodingKeys>
    ) throws -> DoubleSymbol {
        return try container.decode(DoubleSymbol.self, forKey: .symbol)
    }

    // MARK: instance functions
    public func isMetBy(dataPoint: HourlyDataPoint, for forecast: Forecast) -> Bool {
        let dataPointValue = measurement.value(for: dataPoint, in: forecast)

        switch symbol {
            case .equalTo: return dataPointValue == value
            case .greaterThan: return dataPointValue.map { $0 > value } ?? false
            case .lessThan: return dataPointValue.map { $0 < value } ?? false
            case .lessThanOrEqualTo: return dataPointValue.map { $0 <= value } ?? false
            case .greaterThanOrEqualTo: return dataPointValue.map { $0 >= value } ?? false
        }
    }

    public func encodeSymbol(
        in container: inout KeyedEncodingContainer<ConditionProtocolCodingKeys>
    ) throws {
        try container.encode(symbol, forKey: .symbol)
    }
}
