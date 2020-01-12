import UIKit

// MARK: sections
internal enum LocationSelectionSection: CaseIterable {
    case currentLocation
    case results
    case suggestions

    // MARK: computed properties
    internal var hasSectionHeader: Bool {
        return sectionTitle != nil
    }

    internal var sectionTitle: String? {
        switch self {
            case .currentLocation:
                return nil
            case .results:
                return NSLocalizedString("Results", comment: "")
            case .suggestions:
                return NSLocalizedString("Suggestions", comment: "")
        }
    }

    internal var sectionHeaderHeight: CGFloat {
        switch self {
            case .currentLocation: return .tableViewZeroHeaderHeight
            case .results, .suggestions: return UITableView.automaticDimension
        }
    }

    internal var estimatedSectionHeaderHeight: CGFloat {
        switch self {
            case .currentLocation: return .tableViewZeroHeaderHeight
            case .results, .suggestions: return 44
        }
    }

    // MARK: init
    internal init(sectionIndex: Int) {
        switch sectionIndex {
            case 0: self = .currentLocation
            case 1: self = .results
            case 2: self = .suggestions
            default: fatalError("Invalid sectionIndex: \(sectionIndex)")
        }
    }

    // MARK: functions
    internal func numberOfRows(given state: LocationSelectionViewController.State) -> Int {
        switch self {
            case .currentLocation: return 1
            case .results: return state.results.count
            case .suggestions: return state.suggestions.count
        }
    }
}
