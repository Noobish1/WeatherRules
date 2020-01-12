import Foundation

// MARK: BottomAnchoredModalLayout
public enum BottomAnchoredModalLayout {
    // MARK: OSVersion
    public enum OSVersion {
        case thirteenPlus
        case twelveAndBelow
    }
    
    // MARK: cases
    case phone
    case pad(OSVersion)
    
    // MARK: computed properties
    public var containerViewBottomInset: CGFloat {
        switch self {
            case .phone, .pad(.twelveAndBelow): return 0
            case .pad(.thirteenPlus): return 13
        }
    }
    
    public var gradientViewBottomOffset: CGFloat {
        switch self {
            case .phone: return 0
            case .pad(.thirteenPlus): return 63
            case .pad(.twelveAndBelow): return 50
        }
    }
    
    // MARK: init
    public init() {
        switch InterfaceIdiom.current {
            case .phone:
                self = .phone
            case .pad:
                if #available(iOS 13, *) {
                    self = .pad(.thirteenPlus)
                } else {
                    self = .pad(.twelveAndBelow)
                }
        }
    }
}
