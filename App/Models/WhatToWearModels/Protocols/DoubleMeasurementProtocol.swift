import Foundation
import WhatToWearCore

// MARK: DoubleMeasurementProtocol
public protocol DoubleMeasurementProtocol: MeasurementProtocol, BasicDoubleMeasurementProtocol {
    var symbol: DoubleSymbol.Type { get }
}
