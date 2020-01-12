import SnapKit
import Then
import UIKit
import WhatToWearAssets
import WhatToWearCoreUI

internal final class LocationSelectionContentView: CodeBackedView, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = LocationSelectionContentView

        case searchBar = "searchBar"
        case backButton = "backButton"
        case tableView = "tableView"
        case searchBarTextField = "searchBarTextField"
    }

    // MARK: Layout
    internal enum Layout {
        case phone
        case padLocationsScreen
        case padWelcomeScreen
        
        // MARK: computed properties
        internal var hasBackButton: Bool {
            switch self {
                case .phone: return true
                case .padLocationsScreen: return true
                case .padWelcomeScreen: return false
            }
        }
        
        internal var hasDoneButton: Bool {
            switch self {
                case .phone: return false
                case .padLocationsScreen: return true
                case .padWelcomeScreen: return true
            }
        }
        
        // MARK: init
        internal init(context: LocationSelectionViewController.Context) {
            let interfaceIdiom = InterfaceIdiom.current
            
            switch (interfaceIdiom, context) {
                // back button on left, activity indicator on right
                case (.phone, _): self = .phone
                // back button on left, activity indicator and done button on right
                case (.pad, .locationsScreen): self = .padLocationsScreen
                // no back button, activity indicator and done button on right
                case (.pad, .welcomeScreen): self = .padWelcomeScreen
            }
        }
    }
    
    // MARK: properties
    internal let tableView = UITableView(frame: UIScreen.main.bounds, style: .grouped).then {
        $0.backgroundColor = .clear
        $0.panGestureRecognizer.cancelsTouchesInView = false
        $0.separatorStyle = .none
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.tableView)
    }
    internal let searchBar = UISearchBar().then {
        $0.placeholder = NSLocalizedString("Enter location", comment: "")
        $0.searchBarStyle = .minimal
        $0.tintColor = .white
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.searchBar)
    }
    private let activityIndicator = UIActivityIndicatorView(style: .white)
    // swiftlint:disable implicitly_unwrapped_optional
    private var activityIndicatorZeroWidthConstraint: Constraint!
    // swiftlint:enable implicitly_unwrapped_optional
    
    private let context: LocationSelectionViewController.Context
    private let layout: Layout
    private let onBack: () -> Void
    private let onDone: () -> Void
    
    // MARK: init
    internal init(
        context: LocationSelectionViewController.Context,
        onBack: @escaping () -> Void,
        onDone: @escaping () -> Void
    ) {
        self.context = context
        self.layout = Layout(context: context)
        self.onBack = onBack
        self.onDone = onDone
        
        super.init(frame: .zero)

        setupViews()
    }

    // MARK: making
    private func makeDoneButton() -> UIButton {
        return UIButton(type: .system).then {
            $0.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
            $0.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        }
    }
    
    private func makeBackButton() -> UIButton {
        return UIButton().then {
            $0.setImage(R.image.backButton(), for: .normal)
            $0.setTitle("", for: .normal)
            $0.tintColor = UIColor.white.darker(by: 30.percent)
            $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.backButton)
            $0.accessibilityLabel = NSLocalizedString("Back Button", comment: "")
            $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        }
    }
    
    // MARK: setup
    private func setupViews() {
        if layout.hasBackButton {
            let backButton = makeBackButton()
            
            add(subview: backButton, withConstraints: { make in
                make.top.equalToSuperview()
                make.leading.equalToSuperview()
                make.width.equalTo(40)
            })
            
            add(subview: searchBar, withConstraints: { make in
                make.top.equalToSuperview()
                make.leading.equalTo(backButton.snp.trailing)
                make.height.equalTo(backButton)
            })
        } else {
            add(subview: searchBar, withConstraints: { make in
                make.top.equalToSuperview()
                make.leading.equalToSuperview()
            })
        }
        
        if let textField = searchBar.firstSubview(ofType: UITextField.self) {
            textField.textColor = .white
            textField.accessibilityIdentifier = AccessibilityIdentifiers.searchBarTextField.rawValue
        }
        
        add(subview: activityIndicator, withConstraints: { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(searchBar.snp.trailing)
            
            if !layout.hasDoneButton {
                make.trailing.equalToSuperview().inset(10)
            }
            
            make.size.equalTo(20).priority(.high)
            make.centerY.equalTo(searchBar)
            activityIndicatorZeroWidthConstraint = make.width.equalTo(0).priority(.almostRequired).constraint
        })
        
        if layout.hasDoneButton {
            let doneButton = makeDoneButton()
            
            add(subview: doneButton, withConstraints: { make in
                make.top.equalToSuperview()
                make.leading.equalTo(activityIndicator.snp.trailing).offset(10)
                make.trailing.equalToSuperview().inset(10)
            })
        }
        
        add(subview: tableView, withConstraints: { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        })
    }
    
    // MARK: animating the activity indicator
    internal func startAnimatingIndicator() {
        activityIndicatorZeroWidthConstraint.update(priority: .low)
        activityIndicator.startAnimating()
    }
    
    internal func stopAnimatingIndicator() {
        activityIndicatorZeroWidthConstraint.update(priority: .almostRequired)
        activityIndicator.stopAnimating()
    }
    
    // MARK: interface actions
    @objc
    private func doneButtonTapped() {
        onDone()
    }
    
    @objc
    private func backButtonTapped() {
        onBack()
    }
}
