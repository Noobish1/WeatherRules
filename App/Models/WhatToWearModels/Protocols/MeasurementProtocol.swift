import Foundation

// MARK: MeasurementProtocol
public protocol MeasurementProtocol: BasicMeasurementProtocol, Equatable {
    associatedtype Symbol: SymbolProtocol

    var symbol: Symbol.Type { get }
}
