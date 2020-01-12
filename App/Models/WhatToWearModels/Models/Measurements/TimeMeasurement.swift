import Foundation

// MARK: TimeMeasurement
public struct TimeMeasurement: MeasurementProtocol {
    public let id: MeasurementID
    public let value: MeasurementValue<Date?>
    public let name: String
    public let explanation: String
    public let symbol = TimeSymbol.self

    // MARK: computed properties
    public var basicValue: BasicMeasurementValue {
        return value.basicValue
    }
}

// MARK: Equatable
extension TimeMeasurement: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        // Have to implement this because MeasurementValue isn't Equatable (because it's made up of closures)
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.symbol == rhs.symbol
    }
}

// MARK: CustomStringConvertible
extension TimeMeasurement: CustomStringConvertible {
    public var description: String {
        return "TimeMeasurement(id: \(id), name: \(name), symbol: \(symbol))"
    }
}
