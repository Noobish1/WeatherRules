import Foundation
import WhatToWearModels
import WhatToWearCommonModels
import WhatToWearCommonTesting

extension SelectableCondition {
    public enum Fixtures {
        public enum WindDirection: FixtureProtocol {
            public typealias EnclosingType = SelectableCondition<WhatToWearCommonModels.WindDirection>
            
            case valid
            
            public var url: URL {
                switch self {
                    case .valid: return R.file.windDirectionConditionJson()!
                }
            }
        }
        
        public enum PrecipitationType: FixtureProtocol {
            public typealias EnclosingType = SelectableCondition<WhatToWearCommonModels.PrecipitationType>
            
            case valid
            
            public var url: URL {
                switch self {
                    case .valid: return R.file.precipConditionJson()!
                }
            }
        }
        
        public enum DayOfWeek: FixtureProtocol {
            public typealias EnclosingType = SelectableCondition<WhatToWearCommonModels.DayOfWeek>
            
            case valid
            
            public var url: URL {
                switch self {
                    case .valid: return R.file.dayOfWeekConditionJson()!
                }
            }
        }
    }
}
