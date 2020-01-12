import Quick
import Nimble
@testable import WhatToWearCore

internal final class CGSizeSpec: QuickSpec {
    internal override func spec() {
        describe("CGSize") {
            describe("its rotatedby") {
                var size: CGSize!
                var returnedSize: CGSize!
                var radians: CGFloat!

                beforeEach {
                    size = CGSize(
                        width: CGFloat.wtw.random(),
                        height: CGFloat.wtw.random()
                    )
                    radians = CGFloat.wtw.random()
                    returnedSize = size.rotatedBy(
                        radians: radians
                    )
                }

                it("should return the rotated size") {
                    expect(returnedSize.width) == abs(size.width * cos(radians)) + abs(size.height * sin(radians))
                    expect(returnedSize.height) == abs(size.width * sin(radians)) + abs(size.height * cos(radians))
                }
            }
        }
    }
}
