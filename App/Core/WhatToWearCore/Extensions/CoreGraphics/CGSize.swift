import CoreGraphics

extension CGSize {
    public func rotatedBy(radians: CGFloat) -> CGSize {
        return CGSize(
            width: abs(width * cos(radians)) + abs(height * sin(radians)),
            height: abs(width * sin(radians)) + abs(height * cos(radians))
        )
    }
}
