import CoreLocation
import ErrorRecorder
import SnapKit
import Then
import UIKit
import WhatToWearCoreUI
import WhatToWearModels

internal final class CurrentLocationViewController: CodeBackedViewController {
    // MARK: state
    private enum State {
        case initial
        case fetchingCurrentLocation
        case permissionDenied(alert: UIAlertController)
        case fetchingFailed(alert: UIAlertController)
        case reverseGeocoding
        case fetchCompleted

        // MARK: computed properties
        fileprivate var labelText: String {
            switch self {
                case .initial, .fetchingCurrentLocation, .permissionDenied, .fetchingFailed:
                    return NSLocalizedString("Fetching current location", comment: "")
                case .reverseGeocoding:
                    return NSLocalizedString("Reverse Geocoding", comment: "")
                case .fetchCompleted:
                    return NSLocalizedString("Fetching Complete!", comment: "")
            }
        }

        // MARK: configuration
        fileprivate func configure(activityIndicator: UIActivityIndicatorView) {
            switch self {
                case .initial, .permissionDenied,
                     .fetchingFailed, .fetchCompleted:
                    activityIndicator.stopAnimating()
                case .fetchingCurrentLocation, .reverseGeocoding:
                    activityIndicator.startAnimating()
            }
        }
    }

    // MARK: properties
    private let onSuccess: (ValidLocation, CurrentLocationViewController) -> Void
    private let onCancel: (CurrentLocationViewController) -> Void
    private let activityIndicator = UIActivityIndicatorView(style: .white)
    private let label = UILabel().then {
        $0.textColor = .white
        $0.textAlignment = .center
    }
    private let cancelButtonTopSeparatorView = SeparatorView()
    private lazy var cancelButton = CustomButton(color: Colors.blueButton).then {
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        $0.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    private lazy var locationFetcher = CurrentLocationFetcher(
        onComplete: { [weak self] result in
            self?.handleLocationFetchResult(result)
        }
    )
    private let geocoder = CLGeocoder()
    private var state: State = .initial

    // MARK: init
    internal init(
        onSuccess: @escaping (ValidLocation, CurrentLocationViewController) -> Void,
        onCancel: @escaping (CurrentLocationViewController) -> Void
    ) {
        self.onSuccess = onSuccess
        self.onCancel = onCancel

        super.init()
    }

    // MARK: setup
    private func setupOurselves() {
        view.backgroundColor = Colors.blueButton

        BorderConfigurator.configureBorder(for: view)
    }

    private func setupOnTapToDismissHandler() {
        guard let presentationController = self.presentationController as? DimmedPresentationController else {
            fatalError("\(self)'s presentationController is not a DimmedPresentationController and it should be")
        }

        presentationController.onTapToDismiss = { [weak self] in
            self?.cancelLocationFetching()
        }
    }

    private func setupSubviews() {
        view.add(subview: label, withConstraints: { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        })

        view.add(subview: activityIndicator, withConstraints: { make in
            make.top.equalTo(label.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        })

        view.add(topSeparatorView: cancelButtonTopSeparatorView, beneath: activityIndicator, offset: 20)

        view.add(subview: cancelButton, withConstraints: { make in
            make.top.equalTo(cancelButtonTopSeparatorView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
        })
    }

    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()

        setupOurselves()
        setupOnTapToDismissHandler()
        setupSubviews()

        transition(to: state)
    }

    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        addViewWillAppearNotificationObservers()

        transition(to: .fetchingCurrentLocation, then: { [locationFetcher] in
            locationFetcher.fetchCurrentLocation()
        })
    }

    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Analytics.record(screen: .currentLocation)
    }

    internal override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeViewWillAppearNotificationObservers()
    }

    // MARK: transition
    private func transition(to newState: State, then: (() -> Void)? = nil) {
        newState.configure(activityIndicator: activityIndicator)
        label.text = newState.labelText

        self.state = newState

        DispatchQueue.main.asyncAfter(deadline: 0.8.seconds.fromNow) {
            then?()
        }
    }

    // MARK: notifications
    private func addViewWillAppearNotificationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }

    private func removeViewWillAppearNotificationObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }

    @objc
    private func applicationWillEnterForeground() {
        switch state {
            case .initial, .permissionDenied, .fetchingFailed:
                transition(to: .fetchingCurrentLocation)

                locationFetcher.fetchCurrentLocation()
            case .fetchCompleted, .fetchingCurrentLocation, .reverseGeocoding:
                break
        }
    }

    // MARK: interface actions
    @objc
    private func cancelButtonTapped() {
        cancelLocationFetching()
    }

    // MARK: cancellation
    private func cancelLocationFetching() {
        onCancel(self)
    }

    // MARK: showing alerts
    private func showLocationServicesDisabledAlert() {
        let alert = AlertControllers.locationServicesDisabled(onCancel: { [weak self] _ in
            self?.cancelLocationFetching()
        })

        transition(to: .permissionDenied(alert: alert))

        present(alert, animated: true)
    }

    private func showFetchFailedAlert() {
        let alert = AlertControllers.locationFetchFailed(onRetry: { [locationFetcher] _ in
            locationFetcher.fetchCurrentLocation()
        }, onCancel: { [weak self] _ in
            self?.cancelLocationFetching()
        })

        transition(to: .fetchingFailed(alert: alert))

        present(alert, animated: true)
    }

    // MARK: handling
    private func handleLocationFetchResult(_ result: Result<CLLocation, CurrentLocationFetcher.FetchingError>) {
        switch result {
            case .success(let location):
                transition(to: .reverseGeocoding, then: { [weak self] in
                    guard let strongSelf = self else { return }

                    strongSelf.reverseGeocode(location: location) { placemarks in
                        strongSelf.transition(to: .fetchCompleted, then: {
                            strongSelf.completeFetching(for: location, with: placemarks)
                        })
                    }
                })
            case .failure(.fetchFailed):
                showFetchFailedAlert()
            case .failure(.locationServicesDisabled):
                showLocationServicesDisabledAlert()
        }
    }

    // MARK: Reverse geocoding
    private func reverseGeocode(location: CLLocation, onComplete: @escaping ([CLPlacemark]) -> Void) {
        geocoder.reverseGeocodeLocation(
            location,
            completionHandler: { placemarks, _ in
                onComplete(placemarks ?? [])
            }
        )
    }

    // MARK: Completing
    private func completeFetching(for location: CLLocation, with placemarks: [CLPlacemark]) {
        if let firstPlacemark = placemarks.compactMap(ValidLocation.init).first {
            onSuccess(firstPlacemark, self)
        } else {
            onSuccess(ValidLocation(location: location), self)
        }
    }
}
