import ErrorRecorder
import Foundation
import Moya
import RxSwift
import WhatToWearCore
import WhatToWearCoreComponents
import WhatToWearModels

public final class AppLookupClient {
    // MARK: properties
    private let appLookupProvider = MoyaProvider<AppLookupService>()

    // MARK: init
    public init() {}

    // MARK: API calls
    public func lookup() -> Single<SearchResponse> {
        return appLookupProvider.rx
            .request(.lookup)
            .map(SearchResponse.self)
            .do(onSuccess: { _ in
                Analytics.record(event: .lookupRequest)
            }, onError: { error in
                let ourError = WTWError(
                    format: "App lookup request failed with error",
                    arguments: [error.localizedDescription]
                )

                ErrorRecorder.record(ourError)
            })
    }
}
