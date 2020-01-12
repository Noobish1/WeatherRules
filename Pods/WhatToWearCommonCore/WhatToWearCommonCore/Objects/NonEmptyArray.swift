// From: https://github.com/khanlou/NonEmptyArray
import Foundation

// MARK: NonEmptyArray
public struct NonEmptyArray<Element> {
    // MARK: DecodingError
    internal enum DecodingError: Error, Equatable {
        case emptyArray
    }
    
    // MARK: properties
    fileprivate var elements: [Element]

    // MARK: computed properties
    public var count: Int {
        return elements.count
    }

    public var first: Element {
        // swiftlint:disable force_unwrapping
        return elements.first!
        // swiftlint:enable force_unwrapping
    }

    public var last: Element {
        // swiftlint:disable force_unwrapping
        return elements.last!
        // swiftlint:enable force_unwrapping
    }

    public var isEmpty: Bool {
        return false
    }

    public var nonEmptyIndices: NonEmptyArray<Self.Index> {
        let array = Array(self.indices)

        // swiftlint:disable force_unwrapping
        return NonEmptyArray<Self.Index>(array: array)!
        // swiftlint:enable force_unwrapping
    }

    // MARK: init
    public init(elements: Element...) {
        self.elements = elements
    }

    public init(firstElement: Element, rest: [Element]) {
        self.elements = [firstElement].byAppending(rest)
    }

    public init?(array: [Element]) {
        guard !array.isEmpty else {
            return nil
        }
        self.elements = array
    }

    // MARK: insertion
    public mutating func insert<C: Collection>(contentsOf collection: C, at index: Index) where C.Iterator.Element == Element {
        elements.insert(contentsOf: collection, at: index)
    }

    public mutating func insert(_ newElement: Element, at index: Index) {
        elements.insert(newElement, at: index)
    }

    // MARK: appending
    public mutating func append(_ newElement: Element) {
        elements.append(newElement)
    }

    public func byAppending(_ newElement: Element) -> Self {
        var copy = self
        copy.append(newElement)
        return copy
    }

    // MARK: helpers
    public func toArray() -> [Element] {
        return elements
    }

    public mutating func removeLastElementAndAddElementToStart(_ element: Element) {
        elements.insert(element, at: 0)
        elements.removeLast()
    }

    public mutating func removeFirstElementAndAddElementToEnd(_ element: Element) {
        elements.append(element)
        elements.removeFirst()
    }

    // MARK: mapping
    public func map<T>(_ transform: (Element) throws -> T) rethrows -> NonEmptyArray<T> {
        // swiftlint:disable force_unwrapping
        return NonEmptyArray<T>(array: try elements.map(transform))!
        // swiftlint:enable force_unwrapping
    }

    // MARK: min/max
    public func min(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Element {
        // swiftlint:disable force_unwrapping
        return try elements.min(by: areInIncreasingOrder)!
        // swiftlint:enable force_unwrapping
    }

    public func max(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Element {
        // swiftlint:disable force_unwrapping
        return try elements.max(by: areInIncreasingOrder)!
        // swiftlint:enable force_unwrapping
    }

    // MARK: reversing
    public func reversed() -> Self {
        // swiftlint:disable force_unwrapping
        return NonEmptyArray(array: elements.reversed())!
        // swiftlint:enable force_unwrapping
    }

    // MARK: Random
    public func randomIndex() -> Int {
        return Int.random(in: 0...(self.count - 1))
    }

    public func randomElement() -> Element {
        return elements[randomIndex()]
    }

    public func randomSubArray() -> Self {
        let startIndex = Int.random(in: 0...(self.count - 1))
        let endIndex = Int.random(in: startIndex...(self.count - 1))

        // swiftlint:disable force_unwrapping
        return NonEmptyArray(array: Array(self[startIndex...endIndex]))!
        // swiftlint:enable force_unwrapping
    }

    // MARK: Sorting
    public func sorted(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Self {
        // swiftlint:disable force_unwrapping
        return try NonEmptyArray(array: elements.sorted(by: areInIncreasingOrder))!
        // swiftlint:enable force_unwrapping
    }

    // MARK: subscripting
    public subscript (safe index: Int) -> Element? {
        return elements[safe: index]
    }
}

// MARK: Element: Strideable, Element.Stride: SignedInteger
extension NonEmptyArray where Element: Strideable, Element.Stride: SignedInteger {
    public init(range: CountableClosedRange<Element>) {
        self.elements = Array(range)
    }
}

// MARK: Element: Strideable
extension NonEmptyArray where Element: Strideable {
    public init(stride: StrideTo<Element>) {
        self.elements = Array(stride)
    }

    public init(stride: StrideThrough<Element>) {
        self.elements = Array(stride)
    }
}

// MARK: CustomStringConvertible
extension NonEmptyArray: CustomStringConvertible {
    public var description: String {
        return elements.description
    }
}

// MARK: CustomDebugStringConvertible
extension NonEmptyArray: CustomDebugStringConvertible {
    public var debugDescription: String {
        return elements.debugDescription
    }
}

// MARK: Collection
extension NonEmptyArray: Collection {
    public typealias Index = Int

    public var startIndex: Int {
        return 0
    }

    public var endIndex: Int {
        return count
    }

    public func index(after i: Int) -> Int {
        return i + 1
    }
}

// MARK: MutableCollection
extension NonEmptyArray: MutableCollection {
    public subscript(_ index: Int) -> Element {
        get {
            return elements[index]
        }
        set {
            elements[index] = newValue
        }
    }
}

// MARK: Equtable elements
extension NonEmptyArray where Element: Equatable {
    public mutating func replace(_ element: Element, with otherElement: Element) {
        elements.replace(element, with: otherElement)
    }

    public func byReplacing(_ element: Element, with otherElement: Element) -> Self {
        var mutableSelf = self
        mutableSelf.replace(element, with: otherElement)

        return mutableSelf
    }
}

// MARK: Comparable elements
extension NonEmptyArray where Element: Comparable {
    public func min() -> Element {
        // swiftlint:disable force_unwrapping
        return elements.min()!
        // swiftlint:enable force_unwrapping
    }

    public func max() -> Element {
        // swiftlint:disable force_unwrapping
        return elements.max()!
        // swiftlint:enable force_unwrapping
    }

    public func maxIndex() -> Int {
        let max = self.max()

        // swiftlint:disable force_unwrapping
        return self.firstIndex(of: max)!
        // swiftlint:enable force_unwrapping
    }

    public mutating func sort() {
        elements.sort()
    }

    public func sorted() -> Self {
        // swiftlint:disable force_unwrapping
        return NonEmptyArray(array: elements.sorted())!
        // swiftlint:enable force_unwrapping
    }
}

// MARK: Equatable
extension NonEmptyArray: Equatable where Element: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.elements == rhs.elements
    }
}

// MARK: Codable
extension NonEmptyArray: Codable where Element: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let array = try container.decode([Element].self)
        
        if let nonEmptyArray = NonEmptyArray(array: array) {
            self = nonEmptyArray
        } else {
            throw DecodingError.emptyArray
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(toArray())
    }
}

// MARK: NonEmptyArray's with WTWRandomized Elements
extension NonEmptyArray where Element: WTWRandomized {
    public static func wtw_random() -> Self {
        // We can't pass a size to this as we can't trust consumers to pass a number above 1
        let array = [Void](repeating: (), count: .random(in: 5...1000)).map { Element.wtw.random() }

        // swiftlint:disable force_unwrapping
        return NonEmptyArray(array: array)!
        // swiftlint:enable force_unwrapping
    }
}
