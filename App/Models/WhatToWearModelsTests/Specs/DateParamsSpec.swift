import Quick
import Nimble
@testable import WhatToWearModels

internal final class DateParamsSpec: QuickSpec {
    internal override func spec() {
        describe("DataParams") {
            describe("its init with date") {
                describe("the returned params") {
                    var params: DateParams!
                    var expectedDay: Int!
                    var expectedMonth: Int!
                    var expectedYear: Int!

                    beforeEach {
                        let calendar = Calendar.current
                        let date = Date.wtw.random()

                        params = DateParams(date: date, timeZone: .current)
                        expectedDay = calendar.component(.day, from: date)
                        expectedMonth = calendar.component(.month, from: date)
                        expectedYear = calendar.component(.year, from: date)
                    }

                    it("should have its day set to the day of the given date") {
                        expect(params.day) == expectedDay
                    }

                    it("should have its month set to the month of the given date") {
                        expect(params.month) == expectedMonth
                    }

                    it("should have its year set to the year of the given date") {
                        expect(params.year) == expectedYear
                    }
                }
            }

            describe("its less than operator") {
                var lhs: DateParams!
                var rhs: DateParams!

                context("when the lhs year is less than the rhs year") {
                    beforeEach {
                        lhs = DateParams(day: 1, month: 1, year: 2015)
                        rhs = DateParams(day: 1, month: 1, year: 2018)
                    }

                    it("should return true") {
                        expect(lhs < rhs).to(beTrue())
                    }
                }

                context("when the lhs year is greater than the rhs year") {
                    beforeEach {
                        lhs = DateParams(day: 1, month: 1, year: 2018)
                        rhs = DateParams(day: 1, month: 1, year: 2015)
                    }

                    it("should return false") {
                        expect(lhs < rhs).to(beFalse())
                    }
                }

                context("when the lhs year is equal to the rhs year") {
                    context("when the lhs month is less than the rhs month") {
                        beforeEach {
                            lhs = DateParams(day: 1, month: 1, year: 2018)
                            rhs = DateParams(day: 1, month: 5, year: 2018)
                        }

                        it("should return true") {
                            expect(lhs < rhs).to(beTrue())
                        }
                    }

                    context("when the lhs month is greater than the rhs month") {
                        beforeEach {
                            lhs = DateParams(day: 1, month: 5, year: 2018)
                            rhs = DateParams(day: 1, month: 1, year: 2018)
                        }

                        it("should return false") {
                            expect(lhs < rhs).to(beFalse())
                        }
                    }

                    context("when the lhs month is equal to the rhs month") {
                        context("when when the lhs day is less than the rhs day") {
                            beforeEach {
                                lhs = DateParams(day: 1, month: 1, year: 2018)
                                rhs = DateParams(day: 5, month: 1, year: 2018)
                            }

                            it("should return true") {
                                expect(lhs < rhs).to(beTrue())
                            }
                        }

                        context("when the lhs day is greater than the rhs day") {
                            beforeEach {
                                lhs = DateParams(day: 5, month: 1, year: 2018)
                                rhs = DateParams(day: 1, month: 1, year: 2018)
                            }

                            it("should return false") {
                                expect(lhs < rhs).to(beFalse())
                            }
                        }

                        context("when the lhs day is equal to the rhs day") {
                            beforeEach {
                                lhs = DateParams(day: 1, month: 1, year: 2018)
                                rhs = DateParams(day: 1, month: 1, year: 2018)
                            }

                            it("should return false") {
                                expect(lhs < rhs).to(beFalse())
                            }
                        }
                    }
                }
            }
        }
    }
}
