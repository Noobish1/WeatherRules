import CoreGraphics
import Foundation

internal final class ViewPortHandler {
    // MARK: properties
    internal private(set) var contentRect: CGRect
    internal private(set) var chartSize: CGSize
    private let extraOffsets: UIEdgeInsets
    private let minOffset: CGFloat = 10

    // MARK: computed properties
    internal var offset: Offset {
        return Offset(
            top: contentRect.minY,
            left: contentRect.minX,
            bottom: chartSize.height - contentRect.maxY,
            right: chartSize.width - contentRect.maxX
        )
    }

    // MARK: init
    internal init(rect: CGRect, extraOffsets: UIEdgeInsets) {
        self.chartSize = rect.size
        self.contentRect = rect
        self.extraOffsets = extraOffsets
    }

    // MARK: viewports
    internal func updateChartSize(_ size: CGSize) {
        let oldOffset = self.offset

        chartSize = size

        restrainViewPort(offset: oldOffset)
    }

    private func restrainViewPort(offset: Offset) {
        guard offset != self.offset else {
            return
        }

        contentRect.origin.x = offset.left
        contentRect.origin.y = offset.top
        contentRect.size.width = chartSize.width - offset.left - offset.right
        contentRect.size.height = chartSize.height - offset.bottom - offset.top
    }

    internal func restrainViewPort(xAxis: XAxis, leftAxis: YAxis, rightAxis: YAxis) {
        let offset = Offset(
            xAxis: xAxis,
            leftAxis: leftAxis,
            rightAxis: rightAxis,
            minOffset: minOffset,
            extraOffsets: extraOffsets
        )

        restrainViewPort(offset: offset)
    }
}
