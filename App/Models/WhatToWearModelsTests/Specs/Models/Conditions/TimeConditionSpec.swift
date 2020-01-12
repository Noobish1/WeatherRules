import Quick
import Nimble
@testable import WhatToWearModels

internal final class TimeConditionSpec: QuickSpec {
    internal override func spec() {
        describe("TimeCondition") {
            describe("its encoded form") {
                var newData: Data!
                
                beforeEach {
                    let originalCondition = try! TimeCondition.fixtures.valid.object()
                    
                    newData = try! JSONEncoder().encode(originalCondition)
                }
                
                it("should be decodable back into a object") {
                    expect(expression: {
                        try JSONDecoder().decode(TimeCondition.self, from: newData)
                    }).toNot(throwError())
                }
            }
        }
    }
}
