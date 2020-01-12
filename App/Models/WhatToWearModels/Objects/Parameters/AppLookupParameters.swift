import CoreLocation
import Foundation
import KeyedAPIParameters

// MARK: AppLookupParamters
public struct AppLookupParameters: Equatable, Hashable, Codable {
    // MARK: properties
    internal let appID: String

    // MARK: init
    public init(appID: String) {
        self.appID = appID
    }
}

// MARK: KeyedAPIParameters
extension AppLookupParameters: KeyedAPIParameters {
    public enum Key: String, ParamJSONKey {
        case appID = "id"
    }

    public func toKeyedDictionary() -> [Key: APIParamConvertible] {
        return [.appID: appID]
    }
}
