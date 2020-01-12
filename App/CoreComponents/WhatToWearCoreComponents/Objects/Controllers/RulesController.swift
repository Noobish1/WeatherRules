import ErrorRecorder
import Foundation
import RxRelay
import WhatToWearCore
import WhatToWearModels

public final class RulesController: DefaultsBackedObservableControllerWithNonOptionalObject {
    // MARK: typealiases
    public typealias Object = StoredRules

    // MARK: static properties
    public static let shared = RulesController()

    // MARK: instance properties
    public let relay: BehaviorRelay<StoredRules>
    public let migrator: AnyMigrator<Object>
    public let config: ControllerConfig

    // MARK: init
    private convenience init() {
        self.init(config: .rules, migrator: AnyMigrator(StoredRulesMigrator()))
    }

    internal init(config: ControllerConfig, migrator: AnyMigrator<Object>) {
        self.config = config
        self.migrator = migrator
        self.relay = BehaviorRelay(value: Self.retrieve(config: config, migrator: migrator))
    }

    // MARK: replacing
    public func replace(rule: Rule, with otherRule: Rule) -> StoredRules {
        return saveRules(afterUpdating: { $0.byReplacing(rule, with: otherRule) })
    }

    public func replace(group: RuleGroup, withContainer container: RuleGroupContainer) -> StoredRules {
        _ = saveGroups(afterUpdating: { $0.byReplacing(group, with: container.group) })

        return saveRules(afterUpdating: {
            $0.byRemoving(contentsOf: container.possibleRulesToRemove)
        })
    }

    // MARK: adding
    public func add(rule: Rule) -> StoredRules {
        return saveRules(afterUpdating: { $0.byAppending(rule) })
    }

    public func add(groupContainer container: RuleGroupContainer) -> StoredRules {
        _ = saveGroups(afterUpdating: { $0.byAppending(container.group) })

        return saveRules(afterUpdating: {
            $0.byRemoving(contentsOf: container.possibleRulesToRemove)
        })
    }

    // MARK: removing
    public func remove(rule: Rule) -> StoredRules {
        return saveRules(afterUpdating: { $0.byRemoving(rule) })
    }

    public func remove(group: RuleGroup) -> StoredRules {
        return saveGroups(afterUpdating: { $0.byRemoving(group) })
    }

    // MARK: saving
    private func saveGroups(afterUpdating update: ([RuleGroup]) -> [RuleGroup]) -> StoredRules {
        let rules = retrieve()
        let newGroups = update(rules.ruleGroups)
        let newStoredRules = StoredRules(ungroupedRules: rules.ungroupedRules, ruleGroups: newGroups)

        return save(newStoredRules)
    }

    private func saveRules(afterUpdating update: ([Rule]) -> [Rule]) -> StoredRules {
        let rules = retrieve()
        let newRules = update(rules.ungroupedRules)
        let newStoredRules = StoredRules(ungroupedRules: newRules, ruleGroups: rules.ruleGroups)

        return save(newStoredRules)
    }
}
