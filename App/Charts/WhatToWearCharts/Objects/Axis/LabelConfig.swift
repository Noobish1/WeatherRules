import Foundation

public struct LabelConfig {
    // MARK: properties
    public let font: UIFont
    public let textColor: UIColor
    public let count: Int
    public let enabled: Bool
    public let forceLabels: Bool

    // MARK: init
    public init(
        font: UIFont = .systemFont(ofSize: 10.0),
        textColor: UIColor,
        count: Int,
        enabled: Bool,
        forceLabels: Bool = false
    ) {
        self.font = font
        self.textColor = textColor
        self.count = count
        self.enabled = enabled
        self.forceLabels = forceLabels
    }
}
