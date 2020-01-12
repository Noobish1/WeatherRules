import Foundation

public protocol Singleton {
    static var shared: Self { get }
}
