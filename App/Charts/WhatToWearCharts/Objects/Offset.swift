import Foundation

// MARK: Offset
internal struct Offset: Equatable {
    internal let top: CGFloat
    internal let left: CGFloat
    internal let bottom: CGFloat
    internal let right: CGFloat
}

// MARK: extensions
extension Offset {
    internal init(
        xAxis: XAxis,
        leftAxis: YAxis,
        rightAxis: YAxis,
        minOffset: CGFloat,
        extraOffsets: UIEdgeInsets
    ) {
        self.init(
            top: max(minOffset, xAxis.labelOffsetTop() + extraOffsets.top),
            left: max(minOffset, leftAxis.labelOffset + extraOffsets.left),
            bottom: max(minOffset, xAxis.labelOffsetBottom() + extraOffsets.bottom),
            right: max(minOffset, rightAxis.labelOffset + extraOffsets.right)
        )
    }
}
