import Foundation
import WhatToWearModels

// MARK: RuleGroupViewModel
internal struct RuleGroupViewModel: Equatable {
    // MARK: properties
    internal let name: String
    internal let underlyingModel: RuleGroup

    // MARK: init
    internal init(ruleGroup: RuleGroup) {
        self.underlyingModel = ruleGroup
        self.name = ruleGroup.name
    }
}
