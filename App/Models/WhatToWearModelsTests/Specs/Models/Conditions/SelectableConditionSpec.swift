import Quick
import Nimble
import WhatToWearCommonModels
@testable import WhatToWearModels

internal final class SelectableConditionSpec: QuickSpec {
    internal override func spec() {
        describe("SelectableCondition") {
            context("when the Value is a PrecipitationType") {
                describe("its encoded form") {
                    var newData: Data!
                    
                    beforeEach {
                        let originalCondition = try! SelectableCondition<PrecipitationType>.Fixtures.PrecipitationType.valid.object()
                        
                        newData = try! JSONEncoder().encode(originalCondition)
                    }
                    
                    it("should be decodable back into a object") {
                        expect(expression: {
                            try JSONDecoder().decode(SelectableCondition<PrecipitationType>.self, from: newData)
                        }).toNot(throwError())
                    }
                }
            }
            
            context("when the Value is a WindDirection") {
                describe("its encoded form") {
                    var newData: Data!
                    
                    beforeEach {
                        let originalCondition = try! SelectableCondition<WindDirection>.Fixtures.WindDirection.valid.object()
                        
                        newData = try! JSONEncoder().encode(originalCondition)
                    }
                    
                    it("should be decodable back into a object") {
                        expect(expression: {
                            try JSONDecoder().decode(SelectableCondition<WindDirection>.self, from: newData)
                        }).toNot(throwError())
                    }
                }
            }
            
            context("when the Value is a DayOfWeek") {
                describe("its encoded form") {
                    var newData: Data!
                    
                    beforeEach {
                        let originalCondition = try! SelectableCondition<DayOfWeek>.Fixtures.DayOfWeek.valid.object()
                        
                        newData = try! JSONEncoder().encode(originalCondition)
                    }
                    
                    it("should be decodable back into a object") {
                        expect(expression: {
                            try JSONDecoder().decode(SelectableCondition<DayOfWeek>.self, from: newData)
                        }).toNot(throwError())
                    }
                }
            }
        }
    }
}
