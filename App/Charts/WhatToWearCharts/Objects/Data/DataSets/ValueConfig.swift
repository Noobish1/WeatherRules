import Foundation

public protocol ValueColorFormatterProtocol {
    func color(for entry: CGPoint) -> UIColor
}

public struct ValueConfig {
    // MARK: TextColor
    public enum TextColorConfig {
        case single(UIColor)
        case formatter(ValueColorFormatterProtocol)
        
        public func color(for entry: CGPoint) -> UIColor {
            switch self {
                case .single(let color):
                    return color
                case .formatter(let formatter):
                    return formatter.color(for: entry)
            }
        }
    }
    
    // MARK: properties
    public let formatter: ValueFormatterProtocol
    public let font: UIFont
    public let textColorConfig: TextColorConfig
    public let shadow: NSShadow
    
    // MARK: init
    public init(
        formatter: ValueFormatterProtocol,
        font: UIFont,
        textColorConfig: TextColorConfig,
        shadow: NSShadow
    ) {
        self.formatter = formatter
        self.font = font
        self.textColorConfig = textColorConfig
        self.shadow = shadow
    }
}
