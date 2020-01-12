import Foundation
import WhatToWearModels

// MARK: Rule creation
extension Rule {
    internal enum CreationError: Error {
        case missingName
        case missingAtLeastOneCondition

        internal var alertText: String {
            switch self {
                case .missingName:
                    return NSLocalizedString("\nRules must have names, you can add one below.", comment: "")
                case .missingAtLeastOneCondition:
                    return NSLocalizedString("\nRules must have at least one condition, you can add one below.", comment: "")
            }
        }
    }

    internal static func create(with state: AddRuleViewController.State) -> Result<Self, CreationError> {
        let trimmedName = state.name?.trimmingCharacters(in: .whitespacesAndNewlines)

        if let name = trimmedName, !name.isEmpty {
            if state.conditions.isEmpty {
                return .failure(.missingAtLeastOneCondition)
            } else {
                return .success(Self(
                    conditions: state.conditions.map { $0.underlyingModel },
                    name: name
                ))
            }
        } else {
            return .failure(.missingName)
        }
    }
}
