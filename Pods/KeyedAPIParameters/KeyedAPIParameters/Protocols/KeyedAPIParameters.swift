import Foundation

public protocol KeyedAPIParameters: APIParameters {
    associatedtype Key: ParamJSONKey
    
    func toKeyedDictionary() -> [Key: APIParamConvertible]
}

extension KeyedAPIParameters {
    public func toParamDictionary() -> [String : APIParamConvertible] {
        return toKeyedDictionary().mapKeys { $0.stringValue }
    }
}
