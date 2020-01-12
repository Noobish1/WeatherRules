import CoreLocation
import Foundation

internal final class CurrentLocationFetcher: NSObject {
    // MARK: error
    internal enum FetchingError: Error {
        case fetchFailed(Error)
        case locationServicesDisabled
    }

    // MARK: properties
    private lazy var locationManager = CLLocationManager().then {
        $0.delegate = self
        $0.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    private let onComplete: (Result<CLLocation, FetchingError>) -> Void

    // MARK: init
    internal init(onComplete: @escaping (Result<CLLocation, FetchingError>) -> Void) {
        self.onComplete = onComplete
    }

    // MARK: fetching
    internal func fetchCurrentLocation() {
        let authStatus = CLLocationManager.authorizationStatus()

        switch authStatus {
            case .denied, .restricted:
                onComplete(.failure(.locationServicesDisabled))
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.requestLocation()
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            @unknown default:
                fatalError("@unknown CLAuthorizationStatus")
        }
    }
}

// MARK: CLLocationManagerDelegate
extension CurrentLocationFetcher: CLLocationManagerDelegate {
    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .denied, .restricted:
                onComplete(.failure(.locationServicesDisabled))
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.requestLocation()
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            @unknown default:
                fatalError("@unknown CLAuthorizationStatus")
        }
    }

    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            fatalError("didUpdateLocations was called without any locations")
        }

        onComplete(.success(lastLocation))
    }

    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onComplete(.failure(.fetchFailed(error)))
    }
}
