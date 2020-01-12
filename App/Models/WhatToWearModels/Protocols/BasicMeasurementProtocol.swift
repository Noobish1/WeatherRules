import Foundation

// MARK: BasicMeasurementProtocol
public protocol BasicMeasurementProtocol {
    var id: MeasurementID { get }
    var basicValue: BasicMeasurementValue { get }
    var name: String { get }
    var explanation: String { get }
}
