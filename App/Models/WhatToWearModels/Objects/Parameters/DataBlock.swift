import Foundation
import KeyedAPIParameters

internal enum DataBlock: String, Codable {
    case currently = "currently"
    case minutely = "minutely"
    case hourly = "hourly"
    case daily = "daily"
    case alerts = "alerts"
    case flags = "flags"
}

extension DataBlock: APIParamConvertible {
    internal func value(forHTTPMethod method: HTTPMethod) -> Any {
        return self.rawValue
    }
}
