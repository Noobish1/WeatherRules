import Foundation
import WhatToWearModels

internal enum MeasurementSymbolPairViewModel {
    internal static func titleForSymbol(for pair: MeasurementSymbolPair) -> String {
        switch pair {
            case .double(measurement: _, symbol: let symbol):
                return DoubleSymbolViewModel.longTitle(for: symbol)
            case .enumeration(measurement: _, symbol: let symbol):
                return SelectableMeasurementSymbolViewModel.longTitle(for: symbol)
            case .time(measurement: _, symbol: let symbol):
                return TimeSymbolViewModel.longTitle(for: symbol)
        }
    }
}
