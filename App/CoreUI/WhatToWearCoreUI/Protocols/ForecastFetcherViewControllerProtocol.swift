import Foundation
import NotificationCenter
import RxSwift
import WhatToWearCoreComponents
import WhatToWearModels
import WhatToWearNetworking

public protocol ForecastFetcherViewControllerProtocol: UIViewController {
    var forecastController: ForecastController { get }
    var darkSkyClient: DarkSkyClient { get }
    var appLookupClient: AppLookupClient { get }
    var fetcherDisposeBag: DisposeBag { get set }

    func transitionToLoadingState(with date: Date)
    func transitionToErrorState(
        with date: Date, location: ValidLocation, onComplete: ((NCUpdateResult) -> Void)?
    )
    func transitionToLoadedState(
        with timedForecast: TimedForecast,
        date: Date,
        location: ValidLocation,
        onComplete: ((NCUpdateResult) -> Void)?
    )
}

extension ForecastFetcherViewControllerProtocol {
    // MARK: fetch
    private func fetchAppLookup() -> Single<LatestAppUpdate?> {
        // This will only fetch at most as much as we fetch forecasts
        let controller = GlobalSettingsController.shared

        guard
            let date = controller.lastAppLookupDate,
            abs(date.timeIntervalSince(Date.now)) > 4.hours
        else {
            return appLookupClient.lookup().map { $0.latestAppUpdate }
        }

        let lastUpdateAvailable = controller.retrieve().lastUpdateAvailable

        return Single.just(lastUpdateAvailable)
    }

    private func fetchForecastWithoutCacheCheck(
        for date: Date,
        location: ValidLocation,
        onComplete: ((NCUpdateResult) -> Void)?
    ) {
        transitionToLoadingState(with: date)

        fetcherDisposeBag = DisposeBag()

        Single
            .zip(
                darkSkyClient.forecast(date: date, location: location),
                fetchAppLookup()
            ) {
                ($0, $1)
            }
            .minimumDuration(0.6)
            .subscribe(onSuccess: { [weak self] forecast, latestAppUpdate in
                guard let strongSelf = self else { return }

                GlobalSettingsController.shared.update(with: latestAppUpdate)

                strongSelf.transitionToLoadedState(
                    with: forecast,
                    date: date,
                    location: location,
                    onComplete: onComplete
                )
            }, onError: { [weak self] _ in
                guard let strongSelf = self else { return }

                strongSelf.transitionToErrorState(
                    with: date,
                    location: location,
                    onComplete: onComplete
                )
            })
            .disposed(by: fetcherDisposeBag)
    }

    public func fetchForecastWithCacheCheck(for date: Date, location: ValidLocation, onComplete: ((NCUpdateResult) -> Void)? = nil) {
        guard let cachedForecast = forecastController.cachedForecast(for: date, location: location) else {
            fetchForecastWithoutCacheCheck(for: date, location: location, onComplete: onComplete)

            return
        }

        transitionToLoadedState(with: cachedForecast, date: date, location: location, onComplete: onComplete)
    }
}
