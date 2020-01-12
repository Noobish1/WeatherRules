import CoreGraphics
import Foundation
import WhatToWearCommonCore
import WhatToWearCore

internal final class Transformer {
    // MARK: properties
    private var matrixValueToPx = CGAffineTransform.identity
    private var matrixOffset = CGAffineTransform.identity

    // MARK: computed properties
    internal var valueToPixelMatrix: CGAffineTransform {
        return matrixValueToPx.concatenating(.identity).concatenating(matrixOffset)
    }

    // MARK: preparation
    internal func prepareMatrixValuePx(xAxis: XAxis, yAxis: YAxis, viewPortHandler: ViewPortHandler) {
        var scaleX = (viewPortHandler.contentRect.width / (xAxis.range.upperBound - xAxis.range.lowerBound))
        var scaleY = (viewPortHandler.contentRect.height / (yAxis.range.upperBound - yAxis.range.lowerBound))

        if scaleX == CGFloat.infinity {
            scaleX = 0.0
        }
        if scaleY == CGFloat.infinity {
            scaleY = 0.0
        }

        matrixValueToPx = CGAffineTransform
            .identity
            .scaledBy(x: scaleX, y: -scaleY)
            .translatedBy(
                x: CGFloat(-xAxis.range.lowerBound),
                y: CGFloat(-yAxis.range.lowerBound)
            )
    }

    internal func prepareMatrixOffset(using viewPortHandler: ViewPortHandler) {
        matrixOffset = CGAffineTransform(
            translationX: viewPortHandler.offset.left,
            y: viewPortHandler.chartSize.height - viewPortHandler.offset.bottom
        )
    }

    internal func pointValuesToPixel(_ points: NonEmptyArray<CGPoint>) -> NonEmptyArray<CGPoint> {
        return points.map { $0.applying(valueToPixelMatrix) }
    }
}
