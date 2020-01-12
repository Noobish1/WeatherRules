import WhatToWearCoreComponents
import WhatToWearCoreUI
import WhatToWearModels

internal final class LocationsViewController: CodeBackedViewController, NavStackEmbedded {
    // MARK: properties
    private let cellReuseIdentifier = "locationCell"
    private let backgroundView = BasicBackgroundView()
    private lazy var contentView = LocationsContentView(
        onAddTapped: { [weak self] in
            self?.addButtonTapped()
        }
    ).then {
        $0.tableView.dataSource = self
        $0.tableView.delegate = self
        $0.tableView.register(
            SelectableLocationTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier
        )
    }
    private let viewModel: LocationsViewModel
    
    // MARK: status bar
    internal override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: init
    internal init(locationsController: StoredLocationsController) {
        self.viewModel = LocationsViewModel(locationsController: locationsController)
        
        super.init()
        
        self.title = NSLocalizedString("Locations", comment: "")
    }
    
    // MARK: setup
    private func setupViews() {
        view.add(fullscreenSubview: backgroundView)
        
        view.add(subview: contentView, withConstraints: { make in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        })
    }
    
    private func setupBarButtonItemsIfNeeded() {
        guard case .pad = InterfaceIdiom.current else {
            return
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped)
        )
    }
    
    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupNavigation()
        setupBarButtonItemsIfNeeded()
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navController.setNavigationBarHidden(false, animated: animated)
    }
    
    internal override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navController.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: interface actions
    @objc
    private func doneButtonTapped() {
        dismiss(animated: true)
    }
    
    private func addButtonTapped() {
        let vc = LocationSelectionViewController(
            context: .locationsScreen,
            onSelection: { [viewModel, contentView, navController] location in
                viewModel.add(location: location)
                
                contentView.reloadTableView()
                
                navController.popViewController(animated: true)
            }
        )
        
        navController.pushViewController(vc, animated: true)
    }
    
    // MARK: inset updates
    internal override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11, *) {
            contentView.update(bottomInset: view.safeAreaInsets.bottom)
        }
    }
}

// MARK: UITableViewDataSource
extension LocationsViewController: UITableViewDataSource {
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
    
    internal func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard editingStyle == .delete && indexPath != viewModel.selectedLocationIndexPath() else {
            return
        }
        
        viewModel.removeLocation(at: indexPath)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

// MARK: UITableViewDelegate
extension LocationsViewController: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectLocation(at: indexPath)
        
        tableView.reloadData()
    }
    
    internal func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return viewModel.canEditLocation(at: indexPath)
    }
}
