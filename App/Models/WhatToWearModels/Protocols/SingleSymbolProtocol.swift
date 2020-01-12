import Foundation

public protocol SingleSymbolProtocol: SymbolProtocol {
    static var singleSymbol: Self { get }
}
