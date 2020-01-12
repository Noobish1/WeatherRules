import UIKit

public final class RuleTableViewConfigurator {
    // MARK: init
    public init() {}

    // MARK: configuration
    public func configure(tableView: UITableView) {
        tableView.backgroundColor = .clear
        tableView.panGestureRecognizer.cancelsTouchesInView = false
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.delaysContentTouches = false

        if #available(iOS 11.0, *) {
            tableView.insetsContentViewsToSafeArea = false
        }
    }
}
