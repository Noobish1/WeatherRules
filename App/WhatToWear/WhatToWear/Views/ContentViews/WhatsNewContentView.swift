import UIKit
import WhatToWearCoreUI

internal final class WhatsNewContentView: CodeBackedView {
    // MARK: properties
    private let fakeNavBar = UINavigationBar(frame: .zero).then {
        NavBarConfigurator.configure(navBar: $0)

        $0.items = [UINavigationItem(title: NSLocalizedString("What's New", comment: ""))]
    }
    private let navBarBottomSeparatorView = SeparatorView()
    internal lazy var tableView = UITableView(frame: UIScreen.main.bounds).then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 44
        $0.rowHeight = UITableView.automaticDimension
        $0.delaysContentTouches = false
        $0.allowsSelection = false
    }
    private let buttonContainer = UIView()
    private var bottomButtons: [BottomAnchoredButton] = []
    private let context: WhatsNewViewController.Context
    private let onAppStoreButtonTapped: () -> Void
    
    // MARK: init
    internal init(
        context: WhatsNewViewController.Context,
        onAppStoreButtonTapped: @escaping () -> Void
    ) {
        self.context = context
        self.onAppStoreButtonTapped = onAppStoreButtonTapped
        
        super.init(frame: .zero)
        
        setupViews()
    }
    
    // MARK: setup
    private func setupViews() {
        switch context {
            case .settings:
                add(topSeparatorView: navBarBottomSeparatorView)
            case .launch:
                add(subview: fakeNavBar, withConstraints: { make in
                    make.top.equalToSuperview()
                    make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
                    make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
                })

                add(
                    topSeparatorView: navBarBottomSeparatorView,
                    beneath: fakeNavBar.snp.bottom
                )
        }

        add(subview: tableView, withConstraints: { make in
            make.top.equalTo(navBarBottomSeparatorView.snp.bottom)
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
        })

        add(subview: buttonContainer, withConstraints: { make in
            make.top.equalTo(tableView.snp.bottom)
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
            make.bottom.equalToSuperview()
        })

        setupButtons()
    }
    
    private func setupButtons() {
        let appStoreButtonColor: UIColor

        switch context {
            case .settings: appStoreButtonColor = Colors.blueButton
            case .launch: appStoreButtonColor = Colors.orangeButton
        }

        let appStoreButton = BottomAnchoredButton(
            bottomInset: self.wtw_bottomSafeInset,
            bgColor: appStoreButtonColor,
            onTap: onAppStoreButtonTapped
        ).then {
            $0.update(title: NSLocalizedString("Full History", comment: ""))
        }

        switch context {
            case .settings:
                bottomButtons.append(appStoreButton)

                buttonContainer.add(fullscreenSubview: appStoreButton)
            case .launch(let onDismiss):
                let dismissButton = BottomAnchoredButton(
                    bottomInset: self.wtw_bottomSafeInset,
                    bgColor: Colors.blueButton,
                    onTap: {
                        // We dispatch this to let the button show its pressed state
                        // before other heavy things happen elsewhere
                        DispatchQueue.main.async(execute: onDismiss)
                    }
                ).then {
                    $0.update(title: NSLocalizedString("Dismiss", comment: ""))
                }

                bottomButtons.append(dismissButton)

                buttonContainer.add(subview: appStoreButton, withConstraints: { make in
                    make.top.equalToSuperview()
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                    make.height.equalTo(50)
                })

                buttonContainer.add(subview: dismissButton, withConstraints: { make in
                    make.top.equalTo(appStoreButton.snp.bottom)
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                    make.bottom.equalToSuperview()
                })
        }
    }
    
    // MARK: updating
    internal func update(bottomInset: CGFloat) {
        bottomButtons.forEach {
            $0.update(bottomInset: bottomInset)
        }
    }
}
