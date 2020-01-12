import Foundation
import WhatToWearCommonCore
import WhatToWearCore

public enum NonEmptyStoredRules {
    case rulesAndGroups(rules: NonEmptyArray<Rule>, groups: NonEmptyArray<RuleGroup>)
    case rulesOnly(NonEmptyArray<Rule>)
    case groupsOnly(NonEmptyArray<RuleGroup>)

    // MARK: computed properties
    public var emptyableRules: StoredRules {
        return StoredRules(ungroupedRules: self.ungroupedRules, ruleGroups: self.ruleGroups)
    }

    public var ungroupedRules: [Rule] {
        switch self {
            case .rulesAndGroups(rules: let rules, groups: _): return rules.toArray()
            case .rulesOnly(let rules): return rules.toArray()
            case .groupsOnly: return []
        }
    }

    public var ruleGroups: [RuleGroup] {
        switch self {
            case .rulesAndGroups(rules: _, groups: let groups): return groups.toArray()
            case .rulesOnly: return []
            case .groupsOnly(let groups): return groups.toArray()
        }
    }

    // MARK: init
    public init?(storedRules: StoredRules) {
        let nonEmptyRules = NonEmptyArray(array: storedRules.ungroupedRules)
        let nonEmptyGroups = NonEmptyArray(array: storedRules.ruleGroups)

        switch (nonEmptyRules, nonEmptyGroups) {
            case (.none, .none):
                return nil
            case (.some(let rules), .none):
                self = .rulesOnly(rules)
            case (.none, .some(let groups)):
                self = .groupsOnly(groups)
            case (.some(let rules), .some(let groups)):
                self = .rulesAndGroups(rules: rules, groups: groups)
        }
    }
}
