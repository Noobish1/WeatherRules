import Foundation
import WhatToWearModels
import WhatToWearCommonTesting

extension LatestAppUpdate: Fixturable {
    public enum Fixtures: FixtureProtocol {
        public typealias EnclosingType = LatestAppUpdate

        case valid

        public var url: URL {
            switch self {
                case .valid: return R.file.latestAppUpdateJson()!
            }
        }
    }
}
