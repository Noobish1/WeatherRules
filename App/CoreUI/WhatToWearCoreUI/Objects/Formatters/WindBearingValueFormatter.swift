import Foundation
import WhatToWearCharts
import WhatToWearCommonCore
import WhatToWearCore
import WhatToWearModels

// MARK: WindBeringValueFormatter
internal final class WindBearingValueFormatter {
    // MARK: properties
    private let windBearingValues: [CGFloat: Double?]

    // MARK: init
    internal init(windDataEntries: NonEmptyArray<WindDataEntry>) {
        self.windBearingValues = Dictionary(
            uniqueKeysWithValues: windDataEntries.map { ($0.point.x, $0.windBearing) }
        )
    }
}

// MARK: ValueFormatterProtocol
extension WindBearingValueFormatter: ValueFormatterProtocol {
    internal func string(for entry: CGPoint) -> String {
        let bearingValue = windBearingValues[entry.x]
        let bearingDirection = bearingValue.flatMap(ChartWindDirectionViewModel.init)

        return bearingDirection?.arrowString ?? ""
    }
}
