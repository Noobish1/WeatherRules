import Foundation

// MARK: PercentageMeasurementProtocol
public protocol PercentageMeasurementProtocol: DoubleMeasurementProtocol {}

// MARK: Extensions
extension PercentageMeasurementProtocol {
    // MARK: converting between raw and displayed values
    public func rawValue(forDisplayedValue displayedValue: DisplayedValue) -> Double {
        return displayedValue.value / 100
    }
}
