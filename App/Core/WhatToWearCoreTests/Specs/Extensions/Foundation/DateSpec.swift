import Quick
import Nimble
@testable import WhatToWearCore

internal final class DateSpec: QuickSpec {
    internal override func spec() {
        describe("Date") {
            describe("its now") {
                it("should return the current time") {
                    expect(Date.now).to(beCloseTo(Date(), within: 60.seconds))
                }
            }

            describe("its isInSameDayAsDateUsingCalendar") {
                var result: Bool!
                var calendar: Calendar!

                beforeEach {
                    calendar = Calendar.current
                }

                context("when we are in the same day as the given date") {
                    beforeEach {
                        let date = calendar.startOfDay(for: Date()).addingTimeInterval(12.hours)
                        let dateInSameDay = date.addingTimeInterval(6.hours)

                        result = date.isInSameDay(as: dateInSameDay, using: calendar)
                    }

                    it("should return true") {
                        expect(result).to(beTrue())
                    }
                }

                context("when we are not in the same day as the given date") {
                    beforeEach {
                        let date = calendar.startOfDay(for: Date()).addingTimeInterval(12.hours)
                        let dateNotInSameDay = date.addingTimeInterval(-24.hours)

                        result = date.isInSameDay(as: dateNotInSameDay, using: calendar)
                    }

                    it("should return false") {
                        expect(result).to(beFalse())
                    }
                }
            }

            describe("its random") {
                var firstDate: Date!
                var secondDate: Date!

                beforeEach {
                    firstDate = Date.wtw.random()
                    secondDate = Date.wtw.random()
                }

                it("should return a random date") {
                    expect(firstDate) != secondDate
                }
            }
        }
    }
}
