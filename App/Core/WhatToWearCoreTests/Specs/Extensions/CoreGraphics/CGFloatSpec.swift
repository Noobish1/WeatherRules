import Quick
import Nimble
@testable import WhatToWearCore

internal final class CGFloatSpec: QuickSpec {
    internal override func spec() {
        describe("CGFloat") {
            describe("its roundUpToNumberOfDecimalPlaces") {
                it("should roundUp ourselves to the given number of decimal places") {
                    expect(CGFloat(10.123).roundUp(toNumberOfDecimalPlaces: 2)) == 10.13
                }
            }

            describe("its roundDownToNumberOfDecimalPlaces") {
                it("should roundDown ourselves to the given number of decimal places") {
                    expect(CGFloat(10.123).roundDown(toNumberOfDecimalPlaces: 1)) == 10.1
                }
            }
        }
    }
}
