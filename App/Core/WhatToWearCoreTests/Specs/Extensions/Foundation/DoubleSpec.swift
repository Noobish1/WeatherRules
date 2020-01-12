import Quick
import Nimble
@testable import WhatToWearCore

internal final class DoubleSpec: QuickSpec {
    internal override func spec() {
        describe("Double") {
            describe("its random") {
                var first: Double!
                var second: Double!

                beforeEach {
                    first = Double.wtw.random()
                    second = Double.wtw.random()
                }

                it("should return a random double") {
                    expect(first) != second
                }
            }
        }
    }
}
