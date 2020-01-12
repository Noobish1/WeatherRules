import UIKit
import WhatToWearCommonCore
import WhatToWearCore
import WhatToWearCoreUI

internal final class AddRuleGroupFullView: CodeBackedView, RuleAdditionFullViewProtocol {
    // MARK: properties
    internal lazy var tableView = UITableView(frame: UIScreen.main.bounds).then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 44
        $0.rowHeight = UITableView.automaticDimension
        $0.allowsSelectionDuringEditing = true
        $0.delaysContentTouches = false
        $0.setEditing(true, animated: false)

        if #available(iOS 11.0, *) {
            $0.insetsContentViewsToSafeArea = false
        }
    }
    private var viewModels: NonEmptyArray<RuleViewModel>

    // MARK: init
    internal init(viewModels: NonEmptyArray<RuleViewModel>) {
        self.viewModels = viewModels

        super.init(frame: .zero)

        setupViews()
    }

    // MARK: setup
    private func setupViews() {
        add(fullscreenSubview: tableView)
    }

    // MARK: update
    internal func update(with viewModels: NonEmptyArray<RuleViewModel>) {
        self.viewModels = viewModels

        tableView.reloadData()
    }
}
