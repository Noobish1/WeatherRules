import Quick
import Nimble
@testable import WeatherRules

internal final class WindDirectionViewModelSpec: QuickSpec {
    internal override func spec() {
        describe("WindDirectionViewModel") {
            describe("its shortTitle") {
                context("when it is north") {
                    var viewModel: WindDirectionViewModel!

                    beforeEach {
                        viewModel = WindDirectionViewModel(model: .north)
                    }

                    it("should be North") {
                        expect(viewModel.shortTitle) == NSLocalizedString("North", comment: "")
                    }
                }

                context("when south") {
                    var viewModel: WindDirectionViewModel!

                    beforeEach {
                        viewModel = WindDirectionViewModel(model: .south)
                    }

                    it("should be South") {
                        expect(viewModel.shortTitle) == NSLocalizedString("South", comment: "")
                    }
                }

                context("when east") {
                    var viewModel: WindDirectionViewModel!

                    beforeEach {
                        viewModel = WindDirectionViewModel(model: .east)
                    }

                    it("should be East") {
                        expect(viewModel.shortTitle) == NSLocalizedString("East", comment: "")
                    }
                }

                context("when west") {
                    var viewModel: WindDirectionViewModel!

                    beforeEach {
                        viewModel = WindDirectionViewModel(model: .west)
                    }

                    it("should be West") {
                        expect(viewModel.shortTitle) == NSLocalizedString("West", comment: "")
                    }
                }

                context("when north east") {
                    var viewModel: WindDirectionViewModel!

                    beforeEach {
                        viewModel = WindDirectionViewModel(model: .northEast)
                    }

                    it("should be North East") {
                        expect(viewModel.shortTitle) == NSLocalizedString("North East", comment: "")
                    }
                }

                context("when north west") {
                    var viewModel: WindDirectionViewModel!

                    beforeEach {
                        viewModel = WindDirectionViewModel(model: .northWest)
                    }

                    it("should be North West") {
                        expect(viewModel.shortTitle) == NSLocalizedString("North West", comment: "")
                    }
                }

                context("when south east") {
                    var viewModel: WindDirectionViewModel!

                    beforeEach {
                        viewModel = WindDirectionViewModel(model: .southEast)
                    }

                    it("should be South East") {
                        expect(viewModel.shortTitle) == NSLocalizedString("South East", comment: "")
                    }
                }

                context("when south west") {
                    var viewModel: WindDirectionViewModel!

                    beforeEach {
                        viewModel = WindDirectionViewModel(model: .southWest)
                    }

                    it("should be South West") {
                        expect(viewModel.shortTitle) == NSLocalizedString("South West", comment: "")
                    }
                }
            }
        }
    }
}
