import Foundation

public struct GridConfig {
    // MARK: properties
    public let color: UIColor
    public let lineWidth: CGFloat
    public let linesEnabled: Bool

    // MARK: properties
    public init(
        color: UIColor = UIColor.gray.withAlphaComponent(0.9),
        lineWidth: CGFloat = 0.5,
        linesEnabled: Bool
    ) {
        self.color = color
        self.lineWidth = lineWidth
        self.linesEnabled = linesEnabled
    }
}
