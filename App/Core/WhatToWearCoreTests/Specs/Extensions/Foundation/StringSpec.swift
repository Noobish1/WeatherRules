import Quick
import Nimble
@testable import WhatToWearCore

internal final class StringSpec: QuickSpec {
    internal override func spec() {
        describe("String") {
            describe("its random") {
                var first: String!
                var second: String!

                beforeEach {
                    first = String.wtw.random()
                    second = String.wtw.random()
                }

                it("should return a random string") {
                    expect(first) != second
                }
            }
            
            describe("its md5HexString") {
                var actual: String!
                var expected: String!
                
                beforeEach {
                    // This is a regression test again a known md5 string
                    expected = "d41d8cd98f00b204e9800998ecf8427e"
                    actual = "".md5HexString()
                }
                
                it("should return a md5 hash of the string") {
                    expect(actual) == expected
                }
            }
        }
    }
}
