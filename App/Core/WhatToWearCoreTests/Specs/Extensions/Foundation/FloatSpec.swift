import Quick
import Nimble
@testable import WhatToWearCore

internal final class FloatSpec: QuickSpec {
    internal override func spec() {
        describe("Float") {
            describe("its random") {
                var first: Float!
                var second: Float!

                beforeEach {
                    first = Float.wtw.random()
                    second = Float.wtw.random()
                }

                it("should return a random float") {
                    expect(first) != second
                }
            }
        }
    }
}
