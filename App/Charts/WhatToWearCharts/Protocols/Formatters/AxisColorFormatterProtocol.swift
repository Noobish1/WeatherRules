import Foundation

public protocol AxisColorFormatterProtocol: AnyObject {
    func colorForValue(_ value: CGFloat) -> UIColor
}
