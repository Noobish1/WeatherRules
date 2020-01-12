import Quick
import Nimble
import WhatToWearCore
@testable import WhatToWearCore

internal final class TimeIntervalSpec: QuickSpec {
    internal override func spec() {
        describe("TimeInterval") {
            var interval: TimeInterval!

            describe("its seconds") {
                beforeEach {
                    interval = TimeInterval.wtw.random()
                }

                it("should return itself") {
                    expect(interval.seconds) == interval
                }
            }

            describe("its minutes") {
                beforeEach {
                    interval = TimeInterval.wtw.random()
                }

                it("should return itself times 60") {
                    expect(interval.minutes) == interval * 60
                }
            }

            describe("its hours") {
                beforeEach {
                    interval = TimeInterval.wtw.random()
                }

                it("should return itself times 60.minutes") {
                    expect(interval.hours) == interval * 60.minutes
                }
            }

            describe("its days") {
                beforeEach {
                    interval = TimeInterval.wtw.random()
                }

                it("should return itself times 24.hours") {
                    expect(interval.days) == interval * 24.hours
                }
            }

            describe("its fromNow") {
                beforeEach {
                    interval = TimeInterval.wtw.random()
                }

                it("should now plus ourselves") {
                    expect(interval.fromNow) == DispatchTime.now() + interval
                }
            }
        }
    }
}
