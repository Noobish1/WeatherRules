import Foundation
import WhatToWearCommonCore
import WhatToWearCore

// MARK: StoredRules
public struct StoredRules: Codable, Equatable {
    // MARK: properties
    public let ungroupedRules: [Rule]
    public let ruleGroups: [RuleGroup]

    // MARK: computed properties
    public var allRules: [Rule] {
        return ungroupedRules
            .byAppending(ruleGroups.map { $0.rules }.flatMap { $0 })
    }

    // MARK: init
    public init(ungroupedRules: [Rule], ruleGroups: [RuleGroup]) {
        self.ungroupedRules = ungroupedRules
        self.ruleGroups = ruleGroups
    }
}

// MARK: computed properties
extension StoredRules {
    public static var `default`: Self {
        return Self(ungroupedRules: [], ruleGroups: [])
    }
}
