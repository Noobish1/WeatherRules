import Foundation

public protocol WTWRandomized {
    associatedtype wtw: WTWRandomizer where wtw.OuterType == Self
}
