import Foundation

extension Dictionary {
    public func mapKeys <K> (_ map: (Key) throws -> K) rethrows -> [K: Value] {
        var mapped = [K: Value]()
        
        try forEach { mapped[try map($0)] = $1 }
        
        return mapped
    }
}
