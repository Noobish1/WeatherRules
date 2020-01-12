import Foundation

// MARK: APIParamConvertible
public protocol APIParamConvertible {
    func value(forHTTPMethod method: HTTPMethod) -> Any
}

// MARK: NumberParamConvertible
extension APIParamConvertible where Self: NumberParamConvertible {
    public func value(forHTTPMethod method: HTTPMethod) -> Any {
        switch method {
            case .get:
                return String(describing: self)
            case .post, .put, .delete:
                return self.toNSNumber()
        }
    }
}

// MARK: String
extension String: APIParamConvertible {
    public func value(forHTTPMethod method: HTTPMethod) -> Any {
        return self
    }
}

// MARK: Numbers
extension Int: APIParamConvertible {}
extension Float: APIParamConvertible {}
extension Double: APIParamConvertible {}
extension Bool: APIParamConvertible {}

// MARK: NSNull
extension NSNull: APIParamConvertible {
    public func value(forHTTPMethod method: HTTPMethod) -> Any {
        return self
    }
}

// MARK: Optional
extension Optional: APIParamConvertible where Wrapped: APIParamConvertible {
    public func value(forHTTPMethod method: HTTPMethod) -> Any {
        switch self {
            case .some(let value): return value.value(forHTTPMethod: method)
            case .none: return NSNull()
        }
    }
}

// MARK: Array
extension Array: APIParamConvertible where Element: APIParamConvertible {
    public func value(forHTTPMethod method: HTTPMethod) -> Any {
        return self.map { $0.value(forHTTPMethod: method) }
    }
}
