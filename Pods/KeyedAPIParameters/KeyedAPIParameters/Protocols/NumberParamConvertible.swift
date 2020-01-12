import Foundation

public protocol NumberParamConvertible {
    func toNSNumber() -> NSNumber
}

extension Float: NumberParamConvertible {
    public func toNSNumber() -> NSNumber {
        return NSNumber(value: self)
    }
}

extension Double: NumberParamConvertible {
    public func toNSNumber() -> NSNumber {
        return NSNumber(value: self)
    }
}

extension Int: NumberParamConvertible {
    public func toNSNumber() -> NSNumber {
        return NSNumber(value: self)
    }
}

extension Bool: NumberParamConvertible {
    public func toNSNumber() -> NSNumber {
        return NSNumber(value: self)
    }
}
