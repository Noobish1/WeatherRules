import Foundation
import WhatToWearCore
import WhatToWearModels

// MARK: Rule creation
extension RuleGroup {
    internal enum CreationError: Error {
        case missingName
        case missingAtLeastOneRule

        internal var alertText: String {
            switch self {
                case .missingName:
                    return NSLocalizedString("\nRule Groups must have names,\nyou can add one below.", comment: "")
                case .missingAtLeastOneRule:
                    return NSLocalizedString("\nRule Groups must have at least one rule, you can add one below.", comment: "")
            }
        }
    }

    internal static func create(with state: AddRuleGroupViewController.State) -> Result<RuleGroupContainer, CreationError> {
        let trimmedName = state.name?.trimmingCharacters(in: .whitespacesAndNewlines)

        if let name = trimmedName, !name.isEmpty {
            if state.rules.isEmpty {
                return .failure(.missingAtLeastOneRule)
            } else {
                let group = Self(name: name, rules: state.rules.map { $0.underlyingModel })
                let ungroupedRules = state.rules.filter { $0.isExisting }.map { $0.underlyingModel }

                return .success(RuleGroupContainer(
                    group: group,
                    possibleRulesToRemove: ungroupedRules
                ))
            }
        } else {
            return .failure(.missingName)
        }
    }
}
