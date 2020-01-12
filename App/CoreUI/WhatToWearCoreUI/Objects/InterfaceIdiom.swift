import Foundation

public enum InterfaceIdiom {
    case phone
    case pad
    
    // MARK: static computed properties
    public static var current: Self {
        return Self(idiom: UIDevice.current.userInterfaceIdiom)
    }
    
    // MARK: init
    public init(idiom: UIUserInterfaceIdiom) {
        switch idiom {
            case .carPlay, .tv, .unspecified:
                fatalError("Unsupported userInterfaceIdiom")
            case .phone:
                self = .phone
            case .pad:
                self = .pad
            @unknown default:
                fatalError("@unknown userInterfaceIdiom")
        }
    }
}
