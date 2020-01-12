import Quick
import Nimble
@testable import WhatToWearCore

private struct TestWithable: Equatable, Withable {
    fileprivate var property: Int
}

internal final class WithableSpec: QuickSpec {
    internal override func spec() {
        describe("Withable") {
            describe("its with") {
                var actual: TestWithable!
                var expected: TestWithable!

                beforeEach {
                    let newValue = Int.wtw.random()
                    let object = TestWithable(property: Int.wtw.random())

                    actual = object.with(\.property, value: newValue)
                    expected = TestWithable(property: newValue)
                }

                it("should set the property at the given keyPath to the given value") {
                    expect(actual) == expected
                }
            }
        }
    }
}
