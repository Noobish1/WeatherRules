import CoreLocation
import Foundation
import KeyedAPIParameters

public struct ForecastParameters: Equatable, Hashable, Codable {
    // MARK: properties
    internal let excludes: Set<DataBlock> = [.currently, .minutely, .alerts, .flags]
    internal let units = "si"

    // MARK: init
    public init() {}
}

extension ForecastParameters: KeyedAPIParameters {
    public enum Key: String, ParamJSONKey {
        case excludes = "excludes"
        case units = "units"
    }

    public func toKeyedDictionary() -> [Key: APIParamConvertible] {
        return [
            .excludes: Array(excludes),
            .units: units
        ]
    }
}
