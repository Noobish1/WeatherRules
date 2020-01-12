import UIKit
import WhatToWearCoreUI

internal final class LocationsContentView: CodeBackedView {
    // MARK: properties
    private let navBarSeparatorView = SeparatorView()
    internal let tableView = UITableView(frame: UIScreen.main.bounds).then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.allowsMultipleSelection = false
        $0.allowsSelection = true
    }
    private lazy var addButton = BottomAnchoredButton(
        bottomInset: self.wtw_bottomSafeInset,
        onTap: self.onAddTapped
    ).then {
        $0.update(title: NSLocalizedString("Add Location", comment: ""))
    }
    private let onAddTapped: () -> Void
    
    // MARK: init
    internal init(onAddTapped: @escaping () -> Void) {
        self.onAddTapped = onAddTapped
        
        super.init(frame: .zero)
        
        setupViews()
    }
    
    // MARK: setup
    private func setupViews() {
        add(topSeparatorView: navBarSeparatorView)
        
        add(subview: addButton, withConstraints: { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        })
        
        add(subview: tableView, withConstraints: { make in
            make.top.equalTo(navBarSeparatorView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(addButton.snp.top)
        })
    }
    
    // MARK: reloading
    internal func reloadTableView() {
        tableView.reloadData()
    }
    
    // MARK: updating
    internal func update(bottomInset: CGFloat) {
        addButton.update(bottomInset: bottomInset)
    }
}
