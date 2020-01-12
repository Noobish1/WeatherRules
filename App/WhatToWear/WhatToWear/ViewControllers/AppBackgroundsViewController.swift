import Foundation
import Then
import WhatToWearCore
import WhatToWearCoreComponents
import WhatToWearCoreUI
import WhatToWearModels

// MARK: AppBackgroundsViewController
internal class AppBackgroundsViewController: CodeBackedViewController, NavStackEmbedded {
    // MARK: CollectionViewLayoutFactory
    internal enum CollectionViewLayoutFactory {
        internal static func makeLayout(for size: CGSize) -> UICollectionViewFlowLayout {
            return UICollectionViewFlowLayout().then {
                $0.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
                $0.minimumInteritemSpacing = 20
                $0.minimumLineSpacing = 20
                
                if size.height > size.width {
                    $0.scrollDirection = .vertical
                    $0.itemSize = CGSize(width: size.width / 4, height: size.height / 4)
                } else {
                    $0.scrollDirection = .horizontal
                    $0.itemSize = CGSize(
                        width: size.width / 5, height: size.height - 40 - (size.height / 8)
                    )
                }
            }
        }
    }

    // MARK: properties
    private let navBarSeparatorView = SeparatorView()
    private let backgroundView = BasicBackgroundView()
    private let cellReuseIdentifier = "appBackgroundCell"
    private lazy var collectionView = UICollectionView(
        frame: UIScreen.main.bounds,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.delegate = self
        $0.alwaysBounceVertical = self.view.bounds.size.height > self.view.bounds.size.width
        $0.alwaysBounceHorizontal = self.view.bounds.size.width > self.view.bounds.size.height

        $0.register(
            AppBackgroundCollectionViewCell.self,
            forCellWithReuseIdentifier: cellReuseIdentifier
        )
    }
    private let preselection = Singular()
    private let backgrounds = AppBackgroundOptions.allCases

    // MARK: init
    internal override init() {
        super.init()

        self.title = NSLocalizedString("App Background", comment: "")
    }

    // MARK: setup
    private func setupViews() {
        view.add(fullscreenSubview: backgroundView)

        view.add(topSeparatorView: navBarSeparatorView, beneath: self.topLayoutGuide.snp.bottom)

        view.add(subview: collectionView, withConstraints: { make in
            make.top.equalTo(navBarSeparatorView.snp.bottom)
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
            make.bottom.equalToSuperviewOrSafeAreaLayoutGuide()
        })
    }
    
    private func setupCollectionView(for size: CGSize) {
        collectionView.collectionViewLayout = CollectionViewLayoutFactory.makeLayout(for: size)
        collectionView.alwaysBounceVertical = size.height > size.width
        collectionView.alwaysBounceHorizontal = size.width > size.height
    }

    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupNavigation()
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupCollectionView(for: view.bounds.size)
    }

    internal override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        preselection.performOnce {
            preselectInitialBackground()
        }
    }

    // MARK: preselection
    private func preselectInitialBackground() {
        let background = GlobalSettingsController.shared.retrieve().appBackgroundOptions

        if let item = backgrounds.firstIndex(of: background) {
            collectionView.selectItem(
                at: IndexPath(item: item, section: 0),
                animated: false,
                scrollPosition: .top
            )
        }
    }

    // MARK: rotation
    internal override func viewWillTransition(
        to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator
    ) {
        let topIndexPath = collectionView.indexPathsForVisibleItems.first

        coordinator.animate(alongsideTransition: { _ in
            self.setupCollectionView(for: size)

            if let topIndexPath = topIndexPath {
                self.collectionView.scrollToItem(at: topIndexPath, at: .top, animated: true)
            }
        })
    }
}

// MARK: UICollectionViewDataSource
extension AppBackgroundsViewController: UICollectionViewDataSource {
    internal func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: AppBackgroundCollectionViewCell = collectionView.wtw_dequeueReusableCell(
            identifier: cellReuseIdentifier, indexPath: indexPath
        )

        cell.configure(with: backgrounds[indexPath.row])

        return cell
    }

    internal func collectionView(
        _ collectionView: UICollectionView, numberOfItemsInSection section: Int
    ) -> Int {
        return backgrounds.count
    }
}

// MARK: UICollectionViewDelegate
extension AppBackgroundsViewController: UICollectionViewDelegate {
    internal func collectionView(
        _ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath
    ) {
        let option = backgrounds[indexPath.row]

        let currentSettings = GlobalSettingsController.shared.retrieve()
        let newSettings = currentSettings.with(\.appBackgroundOptions, value: option)

        GlobalSettingsController.shared.save(newSettings)
    }
}
