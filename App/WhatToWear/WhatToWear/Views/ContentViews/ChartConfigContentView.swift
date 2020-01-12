import UIKit
import WhatToWearCoreUI

internal final class ChartConfigContentView: CodeBackedView {
    // MARK: properties
    private let navBarSeparatorView = SeparatorView()
    private lazy var tableView = UITableView(frame: UIScreen.main.bounds).then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 44
        $0.rowHeight = UITableView.automaticDimension
        $0.allowsMultipleSelection = true
        $0.register(
            MultiSelectTableViewCell.self,
            forCellReuseIdentifier: configCellReuseIdentifier
        )
    }
    private lazy var applyButton = BottomAnchoredButton(
        bottomInset: self.wtw_bottomSafeInset,
        onTap: { [weak self] in
            self?.onApply()
        }
    ).then {
        $0.update(title: NSLocalizedString("Apply", comment: ""))
    }
    private let onApply: () -> Void
    
    internal let configCellReuseIdentifier = "configCell"
    
    // MARK: computed properties
    internal var selectedIndexPaths: [IndexPath] {
        // We default to an empty array because it returns nil when empty
        return tableView.indexPathsForSelectedRows ?? []
    }
    
    // MARK: init
    internal init(tableViewDataSource: UITableViewDataSource, onApply: @escaping () -> Void) {
        self.onApply = onApply
        
        super.init(frame: .zero)
        
        self.tableView.dataSource = tableViewDataSource
        setupViews()
    }
    
    // MARK: setup
    private func setupViews() {
        add(topSeparatorView: navBarSeparatorView)

        add(subview: tableView, withConstraints: { make in
            make.top.equalTo(navBarSeparatorView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        })

        add(subview: applyButton, withConstraints: { make in
            make.top.equalTo(tableView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        })
    }
    
    // MARK: updating
    internal func update(bottomInset: CGFloat) {
        applyButton.update(bottomInset: bottomInset)
    }
    
    // MARK: preselecting
    internal func preselect(indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
}
