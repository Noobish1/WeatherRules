import CoreGraphics

extension CGFloat {
    // MARK: rounding
    public func roundUp(toNumberOfDecimalPlaces: Int) -> CGFloat {
        let multiplier = pow(10.0, CGFloat(toNumberOfDecimalPlaces))

        let thing = (self * multiplier).rounded(.up)

        return thing / multiplier
    }

    public func roundDown(toNumberOfDecimalPlaces: Int) -> CGFloat {
        let multiplier = pow(10.0, CGFloat(toNumberOfDecimalPlaces))

        let thing = (self * multiplier).rounded(.down)

        return thing / multiplier
    }
}
