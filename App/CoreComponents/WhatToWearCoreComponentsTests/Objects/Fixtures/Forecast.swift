import Foundation
import WhatToWearModels
import WhatToWearCommonTesting
import WhatToWearCommonModels

extension Forecast: Fixturable {
    public enum Fixtures: FixtureProtocol {
        public typealias EnclosingType = Forecast

        case valid
        case dec24_2am
        case dec24_4am

        public var url: URL {
            switch self {
                case .valid: return R.file.forecastJson()!
                case .dec24_2am: return R.file.forecast_2019_12_24_2amJson()!
                case .dec24_4am: return R.file.forecast_2019_12_24_4amJson()!
            }
        }
    }
}
