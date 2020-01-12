import Foundation
import WhatToWearCommonCore

// MARK: Equatable Elements
extension Array where Element: Equatable {
    // MARK: padding
    public func byPadding(with element: Element, upTo length: Int) -> [Element] {
        guard count < length else {
            return self
        }

        return self.byAppending(Array(repeating: element, count: length - count))
    }

    // MARK: swapping
    public func bySwapping(sourceIndex: Int, withDestinationIndex destinationIndex: Int) -> [Element] {
        var array = self
        array.swapAt(sourceIndex, destinationIndex)

        return array
    }

    // MARK: removing multiple elements
    public func byRemoving(contentsOf otherArray: [Element]) -> [Element] {
        var array = self
        array.remove(contentsOf: otherArray)

        return array
    }

    public mutating func remove(contentsOf otherArray: [Element]) {
        otherArray.forEach {
            remove($0)
        }
    }
}

// MARK: General extensions
extension Array {
    // MARK: sorting
    public func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return self.sorted(by: { $0[keyPath: keyPath] < $1[keyPath: keyPath] })
    }
}
