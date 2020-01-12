import Quick
import Nimble
@testable import WhatToWearCore
import WhatToWearCommonCore

private enum TestEnum: NonEmptyCaseIterable {
    case first
    case second
    case third
}

internal final class NonEmptyCaseIterableSpec: QuickSpec {
    internal override func spec() {
        describe("NonEmptyCaseIterable") {
            describe("its nonEmptyCases") {
                var expected: NonEmptyArray<TestEnum>!
                var actual: NonEmptyArray<TestEnum>!
                
                beforeEach {
                    expected = NonEmptyArray<TestEnum>(elements: .first, .second, .third)
                    actual = TestEnum.nonEmptyCases
                }
                
                it("should return an array of all cases") {
                    expect(actual) == expected
                }
            }
        }
    }
}
