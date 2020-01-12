import Foundation
import WhatToWearCore
import WhatToWearModels

internal enum TimeConditionViewModel {
    internal static func title(for condition: TimeCondition) -> String {
        let symbolTitle = TimeSymbolViewModel.shortTitle(for: condition.symbol)
        
        switch condition.symbol {
            case .between:
                let fromTitle = MilitaryTimeViewModel.displayedString(for: condition.value.start, timeZone: .current)
                let toTitle = MilitaryTimeViewModel.displayedString(for: condition.value.end, timeZone: .current)

                return "\(condition.measurement.name) \(symbolTitle)\(String.nbsp)\(fromTitle) & \(toTitle)"
            case .before:
                let timeTitle = MilitaryTimeViewModel.displayedString(for: condition.value.end, timeZone: .current)

                return "\(condition.measurement.name) \(symbolTitle)\(String.nbsp)\(timeTitle)"
            case .after:
                let timeTitle = MilitaryTimeViewModel.displayedString(for: condition.value.start, timeZone: .current)

                return "\(condition.measurement.name) \(symbolTitle)\(String.nbsp)\(timeTitle)"
        }
    }
}
