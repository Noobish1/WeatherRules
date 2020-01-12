import Quick
import Nimble
@testable import WhatToWearCore

internal final class ComparableSpec: QuickSpec {
    internal override func spec() {
        describe("Comparable") {
            describe("its clampedto") {
                var value: Int!
                var limits: ClosedRange<Int>!

                beforeEach {
                    limits = 5...10
                }

                context("when we are less than the lowerbound") {
                    beforeEach {
                        value = 1
                    }

                    it("should return the lowerbound") {
                        expect(value.clamped(to: limits)) == limits.lowerBound
                    }
                }

                context("when we are greater than the upperbound") {
                    beforeEach {
                        value = 15
                    }

                    it("should return the upperbound") {
                        expect(value.clamped(to: limits)) == limits.upperBound
                    }
                }

                context("when we are between the limits") {
                    beforeEach {
                        value = .random(in: limits)
                    }

                    it("should return the same value") {
                        expect(value.clamped(to: limits)) == value
                    }
                }
            }
        }
    }
}
