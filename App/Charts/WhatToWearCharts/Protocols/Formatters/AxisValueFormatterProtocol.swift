import Foundation

public protocol AxisValueFormatterProtocol: AnyObject {
    func stringForValue(_ value: CGFloat) -> String
}
