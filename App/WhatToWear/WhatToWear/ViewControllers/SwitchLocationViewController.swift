import SnapKit
import WhatToWearCoreUI
import WhatToWearModels

internal final class SwitchLocationViewController: CodeBackedViewController, BottomAnchoredInnerViewControllerProtocol {
    // MARK: properties
    private let cellReuseIdentifier = "locationCell"
    private lazy var contentView = SwitchLocationContentView(onDone: self.onDone).then {
        $0.tableView.dataSource = self
        $0.tableView.delegate = self
        $0.tableView.register(
            SelectableLocationTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier
        )
    }
    private let viewModel: LocationsViewModel
    private let onDone: () -> Void
    internal let preferredContentWidth: CGFloat = 350
    
    // MARK: init
    internal init(locationsController: StoredLocationsController, onDone: @escaping () -> Void) {
        self.viewModel = LocationsViewModel(locationsController: locationsController)
        self.onDone = onDone
        
        super.init()
    }
    
    // MARK: setup
    private func setupViews() {
        view.add(fullscreenSubview: contentView)
    }
    
    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    // MARK: inset updates
    internal override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11, *) {
            contentView.update(bottomInset: view.safeAreaInsets.bottom)
        }
    }
}

// MARK: UITableViewDataSource
extension SwitchLocationViewController: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfLocations()
    }
    
    internal func tableView(
        _ tableView: UITableView, cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let location = viewModel.location(at: indexPath)
        
        let cell: SelectableLocationTableViewCell = tableView.wtw_dequeueReusableCell(
            identifier: cellReuseIdentifier, indexPath: indexPath
        )
        cell.configure(with: location, selected: indexPath == viewModel.selectedLocationIndexPath())
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension SwitchLocationViewController: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectLocation(at: indexPath)
        
        tableView.reloadData()
        
        onDone()
    }
}
