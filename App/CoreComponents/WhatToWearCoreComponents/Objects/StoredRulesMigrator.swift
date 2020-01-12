import Foundation
import WhatToWearModels

internal final class StoredRulesMigrator: MigratorProtocol {
    // MARK: typealiases
    internal typealias Object = StoredRules
    
    // MARK: migration
    internal func migrationToNextVersion(from version: StoredRulesVersion) -> Migration {
        switch version {
            case .preVersions:
                return .custom({ data in
                    let rules = try JSONDecoder().decode([Rule].self, from: data)
                    let storedRules = StoredRules(ungroupedRules: rules, ruleGroups: [])

                    return try JSONEncoder().encode(storedRules)
                })
            case .initial:
                return .noMigrationRequired()
        }
    }
}
