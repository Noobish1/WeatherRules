import Foundation
import WhatToWearCommonCore
import WhatToWearCore

// MARK: ConditionProtocolDecodingError
public enum ConditionProtocolDecodingError: Error {
    case measurementMismatch(WeatherMeasurement)
}

// MARK: ConditionProtocolCodingKeys
public enum ConditionProtocolCodingKeys: String, ContainerCodingKey {
    case measurementID = "measurementID"
    case symbol = "symbol"
    case value = "value"
}

// MARK: ConditionProtocol
public protocol ConditionProtocol: BasicConditionProtocol, ContainerCodable where Value: Codable {
    associatedtype MeasurementType: BasicMeasurementProtocol
    associatedtype Symbol: SymbolProtocol
    associatedtype Value

    var measurement: MeasurementType { get }
    var symbol: Symbol { get }
    var value: Value { get }

    init(measurement: MeasurementType, symbol: Symbol, value: Value)

    static func specializedSymbol(
        from container: KeyedDecodingContainer<ConditionProtocolCodingKeys>
    ) throws -> Symbol
    static func specializedMeasurement(from wrapper: WeatherMeasurement) -> MeasurementType?

    func encodeSymbol(
        in container: inout KeyedEncodingContainer<ConditionProtocolCodingKeys>
    ) throws
}

// MARK: Conditions with symbols that conform to SingleSymbolProtocol
extension ConditionProtocol where Symbol: SingleSymbolProtocol {
    public static func specializedSymbol(
        from container: KeyedDecodingContainer<ConditionProtocolCodingKeys>
    ) throws -> Symbol {
        return Symbol.singleSymbol
    }

    public func encodeSymbol(
        in container: inout KeyedEncodingContainer<ConditionProtocolCodingKeys>
    ) throws {
        // do nothing
    }
}

// MARK: Codable
extension ConditionProtocol {
    public init(from container: KeyedDecodingContainer<ConditionProtocolCodingKeys>) throws {
        let measurementID = try container.decode(MeasurementID.self, forKey: .measurementID)
        let measurementWrapper = WeatherMeasurement(id: measurementID)

        guard let measurement = Self.specializedMeasurement(from: measurementWrapper) else {
            throw ConditionProtocolDecodingError.measurementMismatch(measurementWrapper)
        }

        let symbol = try Self.specializedSymbol(from: container)
        let value = try container.decode(Value.self, forKey: .value)

        self.init(measurement: measurement, symbol: symbol, value: value)
    }

    public func encodeValue(
        forKey key: ConditionProtocolCodingKeys,
        in container: inout KeyedEncodingContainer<ConditionProtocolCodingKeys>
    ) throws {
        switch key {
            case .measurementID: try container.encode(measurement.id, forKey: key)
            case .symbol: try encodeSymbol(in: &container)
            case .value: try container.encode(value, forKey: key)
        }
    }
}
