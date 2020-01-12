import Foundation
import WhatToWearModels

internal struct StoredRulesViewModel {
    // MARK: properties
    internal let ungroupedRules: [RuleViewModel]
    internal let ruleGroups: [RuleGroupViewModel]

    // MARK: computed properties
    internal var numberOfSections: Int {
        switch (ungroupedRules.isEmpty, ruleGroups.isEmpty) {
            case (true, true): return 0
            case (true, false), (false, true): return 1
            case (false, false): return 2
        }
    }

    // MARK: init
    internal init(storedRules: StoredRules, system: MeasurementSystem) {
        self.ungroupedRules = storedRules.ungroupedRules.map {
            RuleViewModel(rule: $0, system: system, isExisting: true)
        }
        self.ruleGroups = storedRules.ruleGroups.map(RuleGroupViewModel.init)
    }

    // MARK: functions
    internal func rulesSection(forIndex index: Int) -> RulesFullView.Section {
        switch index {
            case 0 where !ruleGroups.isEmpty:
                return .ruleGroups
            case 0, 1:
                return .ungroupedRules
            default:
                fatalError("Incorrect section index \(index) for storedRules: \(self)")
        }
    }

    internal func numberOfRows(inSection section: Int) -> Int {
        switch rulesSection(forIndex: section) {
            case .ruleGroups:
                return ruleGroups.count
            case .ungroupedRules:
                return ungroupedRules.count
        }
    }
}
