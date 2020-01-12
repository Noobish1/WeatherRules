import Foundation

public enum AnimationDuration {
    case zero
    case reallyShort
    case short
    case shortMedium
    case medium
    case long
    case reallyLong
    case custom(TimeInterval)

    public var value: TimeInterval {
        switch self {
            case .zero: return 0
            case .reallyShort: return 0.05
            case .short: return 0.15
            case .shortMedium: return 0.25
            case .medium: return 0.35
            case .long: return 0.70
            case .reallyLong: return 1
            case .custom(let value): return value
        }
    }

    public var dispatchValue: DispatchTimeInterval {
        return .milliseconds(Int(value * Double(1000)))
    }
}
