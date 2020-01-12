import Foundation

public protocol WTWRandomizer {
    associatedtype OuterType
    
    static func random() -> OuterType
}
