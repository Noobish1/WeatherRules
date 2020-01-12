import Foundation
import WhatToWearCharts

internal final class SunShapeRenderer: ShapeRendererProtocol {
    internal func renderShape(
        context: CGContext,
        config: ScatterChartDataSet.ScatterConfig,
        point: CGPoint,
        color: UIColor
    ) {
        context.setFillColor(color.cgColor)

        let shapeSize = config.shapeSize
        let shapeHalf = shapeSize / 2.0
        let extraYOffset: CGFloat = 15

        var rect = CGRect()
        rect.origin.x = point.x - shapeHalf
        rect.origin.y = point.y - shapeHalf + extraYOffset
        rect.size.width = shapeSize
        rect.size.height = shapeSize

        context.fillEllipse(in: rect)
        context.resetClip()

        let actualCenter = CGPoint(x: point.x, y: point.y + extraYOffset)
        let cornerOffset: CGFloat = 6
        let straightOffset: CGFloat = 15

        let path = UIBezierPath()
        path.lineWidth = 2

        path.move(to: actualCenter)
        // west
        path.addLine(to: CGPoint(x: rect.minX - straightOffset, y: actualCenter.y))
        path.move(to: actualCenter)
        // east
        path.addLine(to: CGPoint(x: rect.maxX + straightOffset, y: actualCenter.y))
        path.move(to: actualCenter)
        // north
        path.addLine(to: CGPoint(x: actualCenter.x, y: rect.minY - straightOffset))
        path.move(to: actualCenter)
        // south
        path.addLine(to: CGPoint(x: actualCenter.x, y: rect.maxY + straightOffset))
        path.move(to: actualCenter)
        // north west
        path.addLine(to: CGPoint(x: rect.minX - cornerOffset, y: rect.minY - cornerOffset))
        path.move(to: actualCenter)
        // north east
        path.addLine(to: CGPoint(x: rect.maxX + cornerOffset, y: rect.origin.y - cornerOffset))
        path.move(to: actualCenter)
        // south west
        path.addLine(to: CGPoint(x: rect.minX - cornerOffset, y: rect.maxY + cornerOffset))
        path.move(to: actualCenter)
        // south east
        path.addLine(to: CGPoint(x: rect.maxX + cornerOffset, y: rect.maxY + cornerOffset))

        path.close()

        color.set()

        path.stroke()
        path.fill()
    }
}
