import Foundation
import WhatToWearCore

// MARK: DoubleSymbol
public enum DoubleSymbol: String, SymbolProtocol, FiniteSetValueProtocol {
    case lessThan = "lessThan"
    case lessThanOrEqualTo = "lessThanOrEqualTo"
    case greaterThan = "greaterThan"
    case greaterThanOrEqualTo = "greaterThanOrEqualTo"
    case equalTo = "equalTo"
}
