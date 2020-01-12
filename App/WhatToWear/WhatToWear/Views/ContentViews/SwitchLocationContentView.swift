import UIKit
import WhatToWearCoreUI

internal final class SwitchLocationContentView: CodeBackedView {
    // MARK: properties
    private let cellHeight: CGFloat = 71
    private let titleTopSeparator = SeparatorView()
    private let titleLabel = UILabel().then {
        $0.text = NSLocalizedString("Switch Location", comment: "")
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    private let titleBottomSeparator = SeparatorView()
    internal lazy var tableView = UITableView(frame: UIScreen.main.bounds).then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.allowsMultipleSelection = false
        $0.allowsSelection = true
        $0.rowHeight = cellHeight
    }
    private var doneButton: BottomAnchoredButton?
    private let onDone: () -> Void
    
    // MARK: init
    internal init(onDone: @escaping () -> Void) {
        self.onDone = onDone
        
        super.init(frame: .zero)
        
        setupViews()
    }
    
    // MARK: setup
    private func setupViews() {
        add(topSeparatorView: titleTopSeparator)
        
        add(subview: titleLabel, withConstraints: { make in
            make.top.equalTo(titleTopSeparator.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
        })
        
        add(topSeparatorView: titleBottomSeparator, beneath: titleLabel, offset: 10)
        
        add(subview: tableView, withConstraints: { make in
            make.top.equalTo(titleBottomSeparator.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            // We use 3.5 so we see half a cell at the bottom which tells the user that they can scroll
            make.height.equalTo(cellHeight * 3.5)
        })
        
        switch InterfaceIdiom.current {
            case .phone:
                let doneButton = makeDoneButton()
                
                self.doneButton = doneButton
                
                add(subview: doneButton, withConstraints: { make in
                    make.top.equalTo(tableView.snp.bottom)
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                    make.bottom.equalToSuperview()
                })
            case .pad:
                tableView.snp.makeConstraints { make in
                    make.bottom.equalToSuperview()
                }
        }
    }
    
    // MARK: making views
    private func makeDoneButton() -> BottomAnchoredButton {
        return BottomAnchoredButton(
            bottomInset: self.wtw_bottomSafeInset,
            onTap: onDone
        ).then {
            $0.update(title: NSLocalizedString("Done", comment: ""))
        }
    }
    
    // MARK: updating
    internal func update(bottomInset: CGFloat) {
        doneButton?.update(bottomInset: bottomInset)
    }
}
