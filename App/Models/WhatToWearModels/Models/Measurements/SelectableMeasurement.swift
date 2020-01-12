import Foundation
import WhatToWearCore

// MARK: SelectableMeasurement
public struct SelectableMeasurement<Value: FiniteSetValueProtocol>: MeasurementProtocol {
    public let id: MeasurementID
    public let value: MeasurementValue<Value?>
    public let name: String
    public let explanation: String
    public let symbol = SelectableMeasurementSymbol.self

    // MARK: computed properties
    public var basicValue: BasicMeasurementValue {
        return value.basicValue
    }
}

// MARK: Equatable
extension SelectableMeasurement: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.symbol == rhs.symbol
    }
}

// MARK: CustomStringConvertible
extension SelectableMeasurement: CustomStringConvertible {
    public var description: String {
        return "SelectableMeasurement(id: \(id), name: \(name), symbol: \(symbol))"
    }
}
