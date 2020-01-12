import Quick
import Nimble
@testable import WeatherRules

internal final class DayOfWeekViewModelSpec: QuickSpec {
    internal override func spec() {
        describe("DayOfWeekViewModel") {
            describe("its shortTitle") {
                var viewModel: DayOfWeekViewModel!

                context("when the day is Monday") {
                    beforeEach {
                        viewModel = DayOfWeekViewModel(model: .monday)
                    }

                    it("should return Monday as a capitalized string") {
                        expect(viewModel.shortTitle) == "Monday"
                    }
                }

                context("when the day is Tuesday") {
                    beforeEach {
                        viewModel = DayOfWeekViewModel(model: .tuesday)
                    }

                    it("should return Tuesday as a capitalized string") {
                        expect(viewModel.shortTitle) == "Tuesday"
                    }
                }

                context("when the day is Wednesday") {
                    beforeEach {
                        viewModel = DayOfWeekViewModel(model: .wednesday)
                    }

                    it("should return Wednesday as a capitalized string") {
                        expect(viewModel.shortTitle) == "Wednesday"
                    }
                }

                context("when the day is Thursday") {
                    beforeEach {
                        viewModel = DayOfWeekViewModel(model: .thursday)
                    }

                    it("should return Thursday as a capitalized string") {
                        expect(viewModel.shortTitle) == "Thursday"
                    }
                }

                context("when the day is Friday") {
                    beforeEach {
                        viewModel = DayOfWeekViewModel(model: .friday)
                    }

                    it("should return Friday as a capitalized string") {
                        expect(viewModel.shortTitle) == "Friday"
                    }
                }

                context("when the day is Saturday") {
                    beforeEach {
                        viewModel = DayOfWeekViewModel(model: .saturday)
                    }

                    it("should return Saturday as a capitalized string") {
                        expect(viewModel.shortTitle) == "Saturday"
                    }
                }

                context("when the day is Sunday") {
                    beforeEach {
                        viewModel = DayOfWeekViewModel(model: .sunday)
                    }

                    it("should return Sunday as a capitalized string") {
                        expect(viewModel.shortTitle) == "Sunday"
                    }
                }
            }
        }
    }
}
