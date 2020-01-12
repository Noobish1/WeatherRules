import Nimble
import Quick
@testable import WhatToWearCoreUI
import WhatToWearModels
import WhatToWearCommonModels

internal final class ChartWindDirectionViewModelSpec: QuickSpec {
    internal override func spec() {
        describe("ChartWindDirectionViewModel") {
            describe("its arrowString") {
                context("when it is north") {
                    var viewModel: ChartWindDirectionViewModel!

                    beforeEach {
                        viewModel = ChartWindDirectionViewModel(windBearing: WindDirection.north.numericalValue)
                    }

                    it("should return a up arrow") {
                        expect(viewModel.arrowString) == "↑"
                    }
                }

                context("when south") {
                    var viewModel: ChartWindDirectionViewModel!

                    beforeEach {
                        viewModel = ChartWindDirectionViewModel(windBearing: WindDirection.south.numericalValue)
                    }

                    it("should return a down arrow") {
                        expect(viewModel.arrowString) == "↓"
                    }
                }

                context("when east") {
                    var viewModel: ChartWindDirectionViewModel!

                    beforeEach {
                        viewModel = ChartWindDirectionViewModel(windBearing: WindDirection.east.numericalValue)
                    }

                    it("should return a right pointing arrow") {
                        expect(viewModel.arrowString) == "→"
                    }
                }

                context("when west") {
                    var viewModel: ChartWindDirectionViewModel!

                    beforeEach {
                        viewModel = ChartWindDirectionViewModel(windBearing: WindDirection.west.numericalValue)
                    }

                    it("should return a left pointing arrow") {
                        expect(viewModel.arrowString) == "←"
                    }
                }

                context("when north east") {
                    var viewModel: ChartWindDirectionViewModel!

                    beforeEach {
                        viewModel = ChartWindDirectionViewModel(windBearing: WindDirection.northEast.numericalValue)
                    }

                    it("should return a diagonal top right pointing arrow") {
                        expect(viewModel.arrowString) == "↗"
                    }
                }

                context("when north west") {
                    var viweModel: ChartWindDirectionViewModel!

                    beforeEach {
                        viweModel = ChartWindDirectionViewModel(windBearing: WindDirection.northWest.numericalValue)
                    }

                    it("should return a diagonal top left pointing arrow") {
                        expect(viweModel.arrowString) == "↖"
                    }
                }

                context("when south east") {
                    var viewModel: ChartWindDirectionViewModel!

                    beforeEach {
                        viewModel = ChartWindDirectionViewModel(windBearing: WindDirection.southEast.numericalValue)
                    }

                    it("should return a diagonal bottom right pointing arrow") {
                        expect(viewModel.arrowString) == "↘"
                    }
                }

                context("when south west") {
                    var viewModel: ChartWindDirectionViewModel!

                    beforeEach {
                        viewModel = ChartWindDirectionViewModel(windBearing: WindDirection.southWest.numericalValue)
                    }

                    it("should return a diagonal bottom left pointing arrow") {
                        expect(viewModel.arrowString) == "↙"
                    }
                }
            }
        }
    }
}
