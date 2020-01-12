import Foundation
import WhatToWearModels
import WhatToWearCommonModels
import WhatToWearCommonTesting

extension HourlyDataPoint: Fixturable {
    public enum Fixtures: FixtureProtocol {
        public typealias EnclosingType = HourlyDataPoint

        case valid
        case withoutPrecip

        public var url: URL {
            switch self {
                case .valid:
                    return R.file.datapointWithPrecipJson()!
                case .withoutPrecip:
                    return R.file.datapointWithoutPrecipJson()!
            }
        }
    }
}
