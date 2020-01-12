import Foundation

public struct RuleGroupContainer {
    public let group: RuleGroup
    public let possibleRulesToRemove: [Rule]

    public init(group: RuleGroup, possibleRulesToRemove: [Rule]) {
        self.group = group
        self.possibleRulesToRemove = possibleRulesToRemove
    }
}
