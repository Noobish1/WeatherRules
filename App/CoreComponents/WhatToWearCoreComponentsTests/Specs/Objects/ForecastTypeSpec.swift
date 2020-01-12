import Quick
import Nimble
@testable import WhatToWearCoreComponents

internal final class ForecastTypeSpec: QuickSpec {
    internal override func spec() {
        describe("ForecastType") {
            describe("its init with date") {
                var type: ForecastType!

                context("when the given date is in the same day as today") {
                    beforeEach {
                        type = ForecastType(date: .now, timeZone: .current)
                    }

                    it("should return present") {
                        expect(type) == .present
                    }
                }

                context("when the given date is not in the same day as today") {
                    context("when the given date is before today") {
                        beforeEach {
                            let pastDate = Date.now.addingTimeInterval(-24.hours)

                            type = ForecastType(date: pastDate, timeZone: .current)
                        }

                        it("should return past") {
                            expect(type) == .past
                        }
                    }

                    context("when the given date is after today") {
                        beforeEach {
                            let futureDate = Date.now.addingTimeInterval(24.hours)

                            type = ForecastType(date: futureDate, timeZone: .current)
                        }

                        it("should return future") {
                            expect(type) == .future
                        }
                    }
                }
            }
        }
    }
}
