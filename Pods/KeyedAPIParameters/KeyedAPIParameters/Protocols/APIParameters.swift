import Foundation

public protocol APIParameters: APIParamConvertible {
    func toParamDictionary() -> [String : APIParamConvertible]
}

extension APIParameters {
    public func toDictionary(forHTTPMethod method: HTTPMethod) -> [String : Any] {
        return toParamDictionary().mapValues { $0.value(forHTTPMethod: method) }
    }
    
    public func value(forHTTPMethod method: HTTPMethod) -> Any {
        return toDictionary(forHTTPMethod: method)
    }
}
