import Quick
import Nimble
@testable import WhatToWearCore

internal final class NormalizerSpec: QuickSpec {
    internal override func spec() {
        describe("Normalizer") {
            describe("its normalize value fromRange toRange") {
                var actual: CGFloat!
                var expected: CGFloat!
                
                beforeEach {
                    expected = 15
                    actual = Normalizer.normalize(value: 0.5, fromRange: 0...1, toRange: 10...20)
                }
                
                it("should normalize a value correctly") {
                    expect(actual) == expected
                }
            }
        }
    }
}
