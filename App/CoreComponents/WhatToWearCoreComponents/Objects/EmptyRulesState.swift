import Foundation

public enum EmptyRulesState {
    case noRules
    case noMetRules

    public var displayedText: String {
        switch self {
            case .noRules:
                return NSLocalizedString("You have no rules or rule groups", comment: "")
            case .noMetRules:
                return NSLocalizedString("No rules or rule groups have been met", comment: "")
        }
    }
}
