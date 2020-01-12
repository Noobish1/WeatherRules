import Foundation

public enum Normalizer {
    private static func interpolate(value: CGFloat, to range: ClosedRange<CGFloat>) -> CGFloat {
        return range.lowerBound * (1 - value) + range.upperBound * value
    }

    private static func uninterpolate(value: CGFloat, from range: ClosedRange<CGFloat>) -> CGFloat {
        let difference = range.upperBound - range.lowerBound
        let bValue = difference != 0 ? difference : 1 / range.upperBound

        return (value - range.lowerBound) / bValue
    }

    public static func normalize(
        value: CGFloat,
        fromRange: ClosedRange<CGFloat>,
        toRange: ClosedRange<CGFloat>
    ) -> CGFloat {
        return interpolate(value: uninterpolate(value: value, from: fromRange), to: toRange)
    }
}
