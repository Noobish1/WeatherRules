import ErrorRecorder
import KeyboardObserver
import MapKit
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit
import WhatToWearCoreUI
import WhatToWearModels

internal final class LocationSelectionViewController: CodeBackedViewController, NavStackEmbedded, Accessible {
    // MARK: typealiases
    internal typealias Section = LocationSelectionSection

    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = LocationSelectionViewController

        case contentView = "contentView"
    }

    // MARK: Context
    internal enum Context {
        case locationsScreen
        case welcomeScreen
    }
    
    // MARK: state
    internal struct State {
        internal var suggestions: [MKLocalSearchCompletion]
        internal var results: [ValidLocation]

        internal static var `default`: Self {
            return State(suggestions: [], results: [])
        }
    }

    // MARK: properties
    private let cellReuseIdentifier = "LocationCell"
    private let currentLocationReuseIdentifier = "CurrentLocationCell"
    private let sectionHeaderReuseIdentifier = "LocationSelectionSectionHeader"
    private lazy var completer = MKLocalSearchCompleter().then {
        $0.delegate = self
        $0.filterType = .locationsOnly
    }
    private let disposeBag = DisposeBag()
    private let keyboardObserver = KeyboardObserver().then {
        $0.isEnabled = false
    }
    private let gradientView = AppBackgroundView()
    private lazy var contentView = LocationSelectionContentView(
        context: context,
        onBack: { [weak self] in
            self?.backButtonTapped()
        },
        onDone: { [weak self] in
            self?.dismiss(animated: true)
        }
    ).then {
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.contentView)
        $0.tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        $0.tableView.register(CurrentLocationTableViewCell.self, forCellReuseIdentifier: currentLocationReuseIdentifier)
        $0.tableView.register(LocationSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: sectionHeaderReuseIdentifier)
        $0.tableView.dataSource = self
        $0.tableView.delegate = self
    }
    private lazy var popRecognizer = CustomInteractivePopRecognizer(controller: navController)
    private var state: State = .default
    private let locationFetchTransitioner = StandardModalTransitioner(allowsTapToDismiss: true)
    private var localSearch = MKLocalSearch(request: MKLocalSearch.Request())

    private let context: Context
    private let onSelection: (ValidLocation) -> Void
    
    // MARK: Status bar
    internal override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: init/deinit
    internal init(context: Context, onSelection: @escaping (ValidLocation) -> Void) {
        self.context = context
        self.onSelection = onSelection

        super.init()
    }

    // MARK: setup
    private func setupViews() {
        view.add(fullscreenSubview: gradientView)

        view.add(subview: contentView, withConstraints: { make in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperviewOrSafeAreaLayoutGuide()
        })
    }

    private func setupInteractivePopRecognizerIfNeeded() {
        guard case .phone = InterfaceIdiom.current else {
            return
        }
        
        popRecognizer = CustomInteractivePopRecognizer(controller: navController)

        navController.interactivePopGestureRecognizer?.delegate = popRecognizer
    }

    private func teardownInteractivePopRecognizerIfNeeded() {
        guard case .phone = InterfaceIdiom.current else {
            return
        }
        
        navController.interactivePopGestureRecognizer?.delegate = nil
    }

    private func setupKeyboardHanding() {
        keyboardObserver.observe { [weak self] event in
            guard let strongSelf = self else { return }

            strongSelf.performDefaultKeyboardHandling(
                for: event, scrollView: strongSelf.contentView.tableView
            )
        }
    }

    private func setupObservables() {
        contentView.searchBar.rx.text
            .map { $0 ?? "" }
            .throttle(.milliseconds(Int(0.3 * 1000)), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                self?.search(text: text)
            })
            .disposed(by: disposeBag)
    }

    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupKeyboardHanding()
        setupObservables()
    }

    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupInteractivePopRecognizerIfNeeded()

        keyboardObserver.isEnabled = true

        contentView.searchBar.becomeFirstResponder()
    }

    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Analytics.record(screen: .locationSelection)
    }

    internal override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        teardownInteractivePopRecognizerIfNeeded()

        keyboardObserver.isEnabled = false
    }

    // MARK: interface actions
    @objc
    private func backButtonTapped() {
        navController.popViewController(animated: true)
    }

    // MARK: search
    private func search(text: String) {
        guard !text.isEmpty else {
            state = .default
            contentView.tableView.reloadData()

            return
        }

        contentView.startAnimatingIndicator()

        updateSearchSuggestions(withText: text)
        updateResults(withText: text)
    }

    // MARK: update
    private func updateActivityIndicator() {
        if completer.isSearching || localSearch.isSearching {
            contentView.startAnimatingIndicator()
        } else {
            contentView.stopAnimatingIndicator()
        }
    }

    private func updateSearchSuggestions(withText text: String) {
        completer.cancel()
        completer.queryFragment = text
    }

    private func updateResults(withText text: String) {
        let request = MKLocalSearch.Request().then {
            $0.naturalLanguageQuery = text
        }

        localSearch.cancel()

        localSearch = MKLocalSearch(request: request)

        localSearch.start { [weak self] response, error in
            guard let strongSelf = self else { return }

            if let response = response {
                strongSelf.state.results = response.mapItems.compactMap(ValidLocation.init)
                strongSelf.contentView.tableView.reloadData()
            } else {
                let ourError = WTWError(
                    format: "MKLocalSearch returned no response and error: %@",
                    arguments: [String(describing: error)]
                )

                ErrorRecorder.record(ourError)
            }

            strongSelf.updateActivityIndicator()
        }
    }

    // MARK: presentation
    private func presentCurrentLocationViewController() {
        contentView.searchBar.resignFirstResponder()

        let vc = CurrentLocationViewController(onSuccess: { [onSelection] location, vc in
            vc.dismiss(animated: true)

            onSelection(location)

            Analytics.record(event: .currentLocationSelected)
        }, onCancel: { vc in
            vc.dismiss(animated: true)
        })
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = locationFetchTransitioner

        present(vc, animated: true, completion: nil)

        Analytics.record(event: .currentLocationTapped)
    }
}

// MARK: MKLocalSearchCompleterDelegate
extension LocationSelectionViewController: MKLocalSearchCompleterDelegate {
    internal func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        state.suggestions = completer.results.filter { $0.subtitle.isEmpty }
        contentView.tableView.reloadData()

        updateActivityIndicator()
    }

    internal func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        let ourError = WTWError(
            format: "MKLocalSearchCompleter failed with error: %@",
            arguments: [String(describing: error)]
        )

        ErrorRecorder.record(ourError)

        updateActivityIndicator()
    }
}

// MARK: UITableViewDataSource
extension LocationSelectionViewController: UITableViewDataSource {
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Section(sectionIndex: section).numberOfRows(given: state)
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(sectionIndex: indexPath.section) {
            case .currentLocation:
                let cell: CurrentLocationTableViewCell = tableView.wtw_dequeueReusableCell(
                    identifier: currentLocationReuseIdentifier, indexPath: indexPath
                )

                return cell
            case .results:
                let cell: LocationTableViewCell = tableView.wtw_dequeueReusableCell(
                    identifier: cellReuseIdentifier, indexPath: indexPath
                )
                cell.configure(with: state.results[indexPath.row])

                return cell
            case .suggestions:
                let cell: LocationTableViewCell = tableView.wtw_dequeueReusableCell(
                    identifier: cellReuseIdentifier, indexPath: indexPath
                )
                cell.configure(with: state.suggestions[indexPath.row])

                return cell
        }
    }
}

// MARK: UITableViewDelegate
extension LocationSelectionViewController: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Section(sectionIndex: section).sectionHeaderHeight
    }

    internal func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return Section(sectionIndex: section).estimatedSectionHeaderHeight
    }

    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = Section(sectionIndex: section)

        guard section.hasSectionHeader else {
            return nil
        }

        let header: LocationSectionHeaderView = tableView.wtw_dequeueReusableHeaderFooterView(
            identifier: sectionHeaderReuseIdentifier
        )
        header.configure(with: section)

        return header
    }

    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch Section(sectionIndex: indexPath.section) {
            case .currentLocation:
                presentCurrentLocationViewController()
            case .results:
                onSelection(state.results[indexPath.row])
            case .suggestions:
                let suggestion = state.suggestions[indexPath.row]

                contentView.searchBar.text = suggestion.title
                search(text: suggestion.title)
        }
    }
}
