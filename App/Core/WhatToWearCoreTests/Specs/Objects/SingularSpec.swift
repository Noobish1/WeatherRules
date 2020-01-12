import Quick
import Nimble
@testable import WhatToWearCore

private class TestClass {
    private let singular = Singular()
    fileprivate var numberOfCalls = 0
    
    fileprivate init() {}
    
    fileprivate func testFunction() {
        singular.performOnce {
            numberOfCalls += 1
        }
    }
}

internal final class SingularSpec: QuickSpec {
    internal override func spec() {
        describe("Singular") {
            describe("its performOnce") {
                var testClass: TestClass!
                
                beforeEach {
                    testClass = TestClass()
                    testClass.testFunction()
                    testClass.testFunction()
                }
                
                it("should only be allowed to call once") {
                    expect(testClass.numberOfCalls) == 1
                }
            }
        }
    }
}
