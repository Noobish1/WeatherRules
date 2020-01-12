import UIKit
import WhatToWearModels

internal protocol RulesFullViewDelegate: AnyObject {
    // MARK: headers
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: RulesFullView.Section) -> UIView?
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: RulesFullView.Section) -> CGFloat
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: RulesFullView.Section) -> CGFloat

    // MARK: editing
    func fullView(
        commitEditingStyle editingStyle: UITableViewCell.EditingStyle, for group: RuleGroup
    )
    func fullView(
        commitEditingStyle editingStyle: UITableViewCell.EditingStyle, for rule: Rule
    )

    // MARK: selection
    func fullView(didSelectGroup group: RuleGroup)
    func fullView(didSelectRule rule: Rule)
}
