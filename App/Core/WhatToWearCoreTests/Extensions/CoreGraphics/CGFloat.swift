import CoreGraphics

extension CGFloat {
    // swiftlint:disable type_name
    internal enum wtw {
    // swiftlint:enable type_name
        internal static func random() -> CGFloat {
            return CGFloat.random(
                in: CGFloat.leastNormalMagnitude...CGFloat.greatestFiniteMagnitude)
        }
    }
}
