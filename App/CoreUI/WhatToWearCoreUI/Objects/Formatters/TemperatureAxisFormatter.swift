import Foundation
import WhatToWearCharts
import WhatToWearCore
import WhatToWearModels

internal final class TemperatureAxisFormatter: YAxisValueFormatterProtocol {
    // MARK: properties
    internal let rawUnit: UnitTemperature
    internal let displayedUnit: UnitTemperature
    
    internal var formatter: MeasurementFormatter {
        return MeasurementFormatters.temperatureFormatter
    }
    
    // MARK: init
    internal init(system: MeasurementSystem) {
        self.rawUnit = .celsius
        self.displayedUnit = system.displayedUnitForTemperatureMeasurement
    }
}
