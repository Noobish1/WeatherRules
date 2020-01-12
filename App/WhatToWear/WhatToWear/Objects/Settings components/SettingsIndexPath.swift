import Foundation

internal enum SettingsIndexPath {
    internal enum Section: Int, CaseIterable {
        case config = 0
        case social = 1
        case other = 2

        // MARK: init
        internal static func make(rawValue: Int) -> Self {
            guard let section = Section(rawValue: rawValue) else {
                fatalError("\(rawValue) is not a valid SettingsViewController Section")
            }

            return section
        }

        // MARK: computed properties
        internal var numberOfRows: Int {
            switch self {
                case .config: return SettingsConfigRow.allCases.count
                case .social: return SettingsSocialRow.allCases.count
                case .other: return SettingsOtherRow.allCases.count
            }
        }

        internal var sectionTitle: String {
            switch self {
                case .config: return NSLocalizedString("Global Settings", comment: "")
                case .social: return NSLocalizedString("Social", comment: "")
                case .other: return NSLocalizedString("Other", comment: "")
            }
        }
    }

    case config(SettingsConfigRow)
    case social(SettingsSocialRow)
    case other(SettingsOtherRow)

    // MARK: computed properties
    internal var shouldHighight: Bool {
        switch self {
            case .config(let row): return row.shouldHighlight
            case .social(let row): return row.shouldHighlight
            case .other(let row): return row.shouldHighlight
        }
    }

    // MARK: init
    internal init(indexPath: IndexPath) {
        switch Section.make(rawValue: indexPath.section) {
            case .config: self = .config(.make(rawValue: indexPath.row))
            case .social: self = .social(.make(rawValue: indexPath.row))
            case .other: self = .other(.make(rawValue: indexPath.row))
        }
    }
}
