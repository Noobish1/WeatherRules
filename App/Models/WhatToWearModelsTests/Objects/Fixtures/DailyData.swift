import Foundation
import WhatToWearModels
import WhatToWearCommonModels
import WhatToWearCommonTesting

extension DailyData: Fixturable {
    public enum Fixtures: FixtureProtocol {
        public typealias EnclosingType = DailyData

        case valid

        public var url: URL {
            switch self {
                case .valid: return R.file.dailydataJson()!
            }
        }
    }
}
