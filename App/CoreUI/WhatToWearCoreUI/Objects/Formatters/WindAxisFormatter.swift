import Foundation
import WhatToWearCharts
import WhatToWearCore
import WhatToWearModels

internal final class WindAxisFormatter: YAxisValueFormatterProtocol {
    // MARK: properties
    internal let rawUnit: UnitSpeed
    internal let displayedUnit: UnitSpeed
    
    internal var formatter: MeasurementFormatter {
        return MeasurementFormatters.measurementFormatter
    }
    
    // MARK: init
    internal init(system: MeasurementSystem) {
        self.rawUnit = .kilometersPerHour
        self.displayedUnit = system.displayedUnitForSpeedMeasurement
    }
}
