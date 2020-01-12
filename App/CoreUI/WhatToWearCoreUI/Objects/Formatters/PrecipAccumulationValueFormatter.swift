import Foundation
import WhatToWearCharts
import WhatToWearCommonCore
import WhatToWearCommonModels
import WhatToWearCore
import WhatToWearModels

// MARK: PrecipAccumulationValueFormatter
internal final class PrecipAccumulationValueFormatter {
    // MARK: properties
    private let data: PrecipitationData
    private let accumulationValues: [CGFloat: Double]
    private let precipTypes: [CGFloat: PrecipitationType?]
    private let system: MeasurementSystem
    
    // MARK: init
    internal init(data: PrecipitationData, system: MeasurementSystem) {
        self.data = data
        self.accumulationValues = Dictionary(
            uniqueKeysWithValues: data.accumationEntries.map { ($0.point.x, $0.accumulation) }
        )
        self.precipTypes = Dictionary(
            uniqueKeysWithValues: data.accumationEntries.map { ($0.point.x, $0.precipType) }
        )
        self.system = system
    }
    
    // MARK: precip types
    private func precipitationType(for entry: CGPoint) -> PrecipitationType {
        switch precipTypes[entry.x] {
            case .none, .rain, .some(.none): return .rain
            case .sleet: return .sleet
            case .snow: return .snow
        }
    }
}

// MARK: ValueFormatterProtocol
extension PrecipAccumulationValueFormatter: ValueFormatterProtocol {
    internal func string(for entry: CGPoint) -> String {
        guard let rawEntryValue = accumulationValues[entry.x] else {
            return ""
        }
        
        let displayedMeasurement: Measurement<UnitLength>
        
        switch precipitationType(for: entry) {
            case .rain, .sleet:
                let displayedUnit = system.displayedUnitForRainAccumulationMeasurement
            
                let measurement = Measurement<UnitLength>(value: Double(rawEntryValue), unit: .millimeters)
                displayedMeasurement = measurement.converted(to: displayedUnit)
            case .snow:
                let displayedUnit = system.displayedUnitForSnowAccumulationMeasurement
            
                let measurement = Measurement<UnitLength>(value: Double(rawEntryValue), unit: .centimeters)
                displayedMeasurement = measurement.converted(to: displayedUnit)
        }
        
        let roundedValue = CGFloat(displayedMeasurement.value).roundUp(toNumberOfDecimalPlaces: 0)
        let roundedIntValue = Int(roundedValue)
        
        guard roundedIntValue > 0 else {
            return ""
        }
        
        return String(roundedIntValue)
    }
}

// MARK: ValueColorFormatterProtocol
extension PrecipAccumulationValueFormatter: ValueColorFormatterProtocol {
    internal func color(for entry: CGPoint) -> UIColor {
        return data.color(for: precipitationType(for: entry))
    }
}
