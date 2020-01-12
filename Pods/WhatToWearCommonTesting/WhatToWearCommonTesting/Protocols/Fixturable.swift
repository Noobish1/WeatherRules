import Foundation

public protocol Fixturable {
    associatedtype Fixtures: FixtureProtocol where Fixtures.EnclosingType == Self
    
    static var fixtures: Fixtures.Type { get }
}

extension Fixturable {
    public static var fixtures: Fixtures.Type {
        return Fixtures.self
    }
}
