import Foundation
import WhatToWearModels
import WhatToWearCommonModels
import WhatToWearCommonTesting

extension Forecast: Fixturable {
    public enum Fixtures: FixtureProtocol {
        public typealias EnclosingType = Forecast

        case valid
        case invalidTimeZone

        public var url: URL {
            switch self {
                case .valid:
                    return R.file.forecastJson()!
                case .invalidTimeZone:
                    return R.file.forecastBadTimezoneJson()!
            }
        }
    }
}
