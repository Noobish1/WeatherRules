import Quick
import Nimble
@testable import WhatToWearModels

internal final class ForecastWindowSpec: QuickSpec {
    internal override func spec() {
        describe("ForecastWindow") {
            describe("its around date") {
                describe("the returned window") {
                    describe("its start") {
                        var expectedStart: DateParams!
                        var actualStart: DateParams!

                        beforeEach {
                            let calendar = Calendar.current
                            let date = Date.wtw.random()
                            expectedStart = DateParams(date: calendar.date(
                                byAdding: .day,
                                value: ForecastWindow.Distance.inThePast.rawValue,
                                to: date
                            )!, timeZone: .current)

                            actualStart = ForecastWindow.around(date: date, timeZone: .current).start
                        }

                        it("should be Distance.inThePast days before the given date") {
                            expect(actualStart) == expectedStart
                        }
                    }

                    describe("its end") {
                        var expectedEnd: DateParams!
                        var actualEnd: DateParams!

                        beforeEach {
                            let calendar = Calendar.current
                            let date = Date.wtw.random()
                            let timeZone = TimeZone.current

                            expectedEnd = DateParams(date: calendar.date(
                                byAdding: .day,
                                value: ForecastWindow.Distance.inTheFuture.rawValue,
                                to: date
                            )!, timeZone: timeZone)

                            actualEnd = ForecastWindow.around(date: date, timeZone: timeZone).end
                        }

                        it("should be Distance.inTheFuture days after the given date") {
                            expect(actualEnd) == expectedEnd
                        }
                    }
                }
            }

            describe("its contains dateParams") {
                context("when the given dateParams are outside the window") {
                    var window: ForecastWindow!
                    var pastParams: DateParams!
                    var futureParams: DateParams!

                    beforeEach {
                        let calendar = Calendar.current
                        let date = Date.wtw.random()
                        let timeZone = TimeZone.current
                        
                        let pastDate = calendar.date(
                            byAdding: .day,
                            value: (ForecastWindow.Distance.inThePast.rawValue -    Int.random(in: 1...10)),
                            to: date
                        )!
                        let futureDate = calendar.date(
                            byAdding: .day,
                            value: (ForecastWindow.Distance.inTheFuture.rawValue + Int.random(in: 1...10)),
                            to: date
                        )!

                        pastParams = DateParams(date: pastDate, timeZone: timeZone)
                        futureParams = DateParams(date: futureDate, timeZone: timeZone)
                        window = ForecastWindow.around(date: date, timeZone: timeZone)
                    }

                    it("should return false") {
                        expect(window.contains(dateParams: pastParams)).to(beFalse())
                        expect(window.contains(dateParams: futureParams)).to(beFalse())
                    }
                }

                context("when the given dateParams are within the window") {
                    var window: ForecastWindow!
                    var withinParams: DateParams!

                    beforeEach {
                        let calendar = Calendar.current
                        let date = Date.wtw.random()
                        let timeZone = TimeZone.current
                        let interval = abs(
                            ForecastWindow.Distance.inThePast.rawValue -
                            ForecastWindow.Distance.inTheFuture.rawValue
                        )
                        let middleDate = calendar.date(
                            byAdding: .day,
                            value: (ForecastWindow.Distance.inThePast.rawValue + interval/2),
                            to: date
                        )!

                        withinParams = DateParams(date: middleDate, timeZone: timeZone)
                        window = ForecastWindow.around(date: date, timeZone: timeZone)
                    }

                    it("should return true") {
                        expect(window.contains(dateParams: withinParams)).to(beTrue())
                    }
                }
            }
        }
    }
}
