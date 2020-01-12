import CoreGraphics
import Foundation

public protocol ShapeRendererProtocol: AnyObject {
    func renderShape(
        context: CGContext,
        config: ScatterChartDataSet.ScatterConfig,
        point: CGPoint,
        color: UIColor
    )
}
