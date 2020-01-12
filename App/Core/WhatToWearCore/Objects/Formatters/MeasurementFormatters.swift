import Foundation
import Then

// MARK: MeasurementFormatters
public enum MeasurementFormatters {
    // MARK: measurementFormatters
    public static let measurementFormatter = MeasurementFormatter().then {
        $0.unitStyle = .short
        $0.unitOptions = .providedUnit
        $0.numberFormatter.maximumFractionDigits = 0
    }
    
    public static let temperatureFormatter = MeasurementFormatter().then {
        $0.unitStyle = .medium
        $0.unitOptions = .providedUnit
        $0.numberFormatter.maximumFractionDigits = 1
        $0.numberFormatter.minimumFractionDigits = 1
    }

    // MARK: unit formatters
    public static let unitFormatter = MeasurementFormatter().then {
        $0.unitStyle = .short
        $0.unitOptions = .providedUnit
    }
}
