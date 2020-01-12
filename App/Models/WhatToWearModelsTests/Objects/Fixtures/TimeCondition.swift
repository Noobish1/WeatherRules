import Foundation
import WhatToWearModels
import WhatToWearCommonTesting

extension TimeCondition: Fixturable {
    public enum Fixtures: FixtureProtocol {
        public typealias EnclosingType = TimeCondition

        case valid

        public var url: URL {
            switch self {
                case .valid: return R.file.timeConditionJson()!
            }
        }
    }
}
