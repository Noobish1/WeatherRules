import Foundation
import WhatToWearModels
import WhatToWearCommonModels
import WhatToWearCommonTesting

extension HourlyForecast: Fixturable {
    public enum Fixtures: FixtureProtocol {
        public typealias EnclosingType = HourlyForecast

        case valid
        case emptyData

        public var url: URL {
            switch self {
                case .valid:
                    return R.file.hourlyforecastJson()!
                case .emptyData:
                    return R.file.hourlyforecastEmptyDataJson()!
            }
        }
    }
}
