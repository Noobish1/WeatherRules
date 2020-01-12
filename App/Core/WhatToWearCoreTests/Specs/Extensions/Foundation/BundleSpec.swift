import Quick
import Nimble
@testable import WhatToWearCore

internal final class BundleSpec: QuickSpec {
    internal override func spec() {
        describe("Bundle") {
            var bundle: Bundle!
            
            beforeEach {
                bundle = Bundle(for: type(of: self))
            }
            
            describe("its version") {
                var actual: OperatingSystemVersion!
                var expected: OperatingSystemVersion!
                
                beforeEach {
                    let versionString: String = bundle.object(forInfoKey: "CFBundleShortVersionString")
                    
                    expected = OperatingSystemVersion.from(string: versionString)
                    actual = bundle.version
                }
                
                it("should return the bundles version") {
                    expect(actual) == expected
                }
            }
            
            describe("its name") {
                var actual: String!
                var expected: String!
                
                beforeEach {
                    expected = "WhatToWearCoreTests"
                    actual = bundle.name
                }
                
                it("should return the bundle's name") {
                    expect(actual) == expected
                }
            }
            
            describe("its object forInfoKey") {
                context("when there is no value for the given key") {
                    it("should fatalError") {
                        expect(expression: { () -> Void? in
                            let _: String = bundle.object(forInfoKey: String.wtw.random())
                            
                            return ()
                        }).to(throwAssertion())
                    }
                }
                
                context("when there is a value for the given key") {
                    var actual: String!
                    var expected: String!
                    
                    beforeEach {
                        expected = "TestValue"
                        actual = bundle.object(forInfoKey: "TestKey")
                    }
                    
                    it("should return the object for the given info key") {
                        expect(actual) == expected
                    }
                }
            }
        }
    }
}
