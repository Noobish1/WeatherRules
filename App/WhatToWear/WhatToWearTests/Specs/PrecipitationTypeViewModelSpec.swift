import Quick
import Nimble
@testable import WeatherRules

internal final class PrecipitationTypeViewModelSpec: QuickSpec {
    internal override func spec() {
        describe("PrecipitationTypeViewModel") {
            context("when it is rain") {
                var viewModel: PrecipitationTypeViewModel!

                beforeEach {
                    viewModel = PrecipitationTypeViewModel(model: .rain)
                }

                describe("its stringRepresentation") {
                    it("should be Rain") {
                        expect(viewModel.shortTitle) == NSLocalizedString("Rain", comment: "")
                    }
                }
            }

            context("when it is snow") {
                var viewModel: PrecipitationTypeViewModel!

                beforeEach {
                    viewModel = PrecipitationTypeViewModel(model: .snow)
                }

                describe("its stringRepresentation") {
                    it("should be Snow") {
                        expect(viewModel.shortTitle) == NSLocalizedString("Snow", comment: "")
                    }
                }
            }

            context("when it is sleet") {
                var viewModel: PrecipitationTypeViewModel!

                beforeEach {
                    viewModel = PrecipitationTypeViewModel(model: .sleet)
                }

                describe("its stringRepresentation") {
                    it("should be Sleet") {
                        expect(viewModel.shortTitle) == NSLocalizedString("Sleet", comment: "")
                    }
                }
            }
        }
    }
}
