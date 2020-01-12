import Foundation
import WhatToWearModels
import WhatToWearCommonModels
import WhatToWearCommonTesting

extension DailyForecast: Fixturable {
    public enum Fixtures: FixtureProtocol {
        public typealias EnclosingType = DailyForecast

        case valid
        case emptyData

        public var url: URL {
            switch self {
                case .valid:
                    return R.file.dailyforecastJson()!
                case .emptyData:
                    return R.file.dailyforecastEmptyDataJson()!
            }
        }
    }
}
