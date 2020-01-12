import Quick
import Nimble
@testable import WhatToWearCore

internal final class HardCodedURLSpec: QuickSpec {
    internal override func spec() {
        describe("HardCodedURL") {
            describe("its init with urlString") {
                context("when the given urlString cannot be converted into a URL") {
                    it("should throw a fatalError") {
                        expect(expression: { _ = HardCodedURL("") }).to(throwAssertion())
                    }
                }
                
                context("when the given urlString can be converted into a URL") {
                    var urlString: String!
                    
                    beforeEach {
                        urlString = "https://www.example.com"
                    }
                    
                    it("should return a HardCodedURL") {
                        expect(HardCodedURL(urlString).url) == URL(string: urlString)!
                    }
                }
            }
            
            describe("its analyticsValue") {
                var urlString: String!
                
                beforeEach {
                    urlString = "https://www.apple.com"
                }
                
                it("should be equal to the inner URLs absoluteString") {
                    expect(HardCodedURL(urlString).analyticsValue) == urlString
                }
            }
        }
    }
}
