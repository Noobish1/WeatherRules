import Quick
import Nimble
@testable import WhatToWearCore

internal final class DictionarySpec: QuickSpec {
    internal override func spec() {
        describe("Dictionary") {
            describe("its value forKey orInsertAndReturn") {
                context("when a value exists for the given key") {
                    var dictionary: [String : Int]!
                    var key: String!
                    var expectedValue: Int!
                    var actualValue: Int!
                    
                    beforeEach {
                        key = String.wtw.random()
                        expectedValue = Int.wtw.random()
                        
                        dictionary = [key : expectedValue]
                        
                        actualValue = dictionary.value(forKey: key, orInsertAndReturn: Int.wtw.random())
                    }
                    
                    it("should return the value") {
                        expect(actualValue) == expectedValue
                    }
                }
                
                context("when a value does not exist for the given key") {
                    var dictionary: [String : Int]!
                    var key: String!
                    var expectedValue: Int!
                    var actualValue: Int!
                    
                    beforeEach {
                        key = String.wtw.random()
                        expectedValue = Int.wtw.random()
                        
                        dictionary = [:]
                        
                        actualValue = dictionary.value(forKey: key, orInsertAndReturn: expectedValue)
                    }
                    
                    it("should store the given newValue") {
                        expect(dictionary[key]) == expectedValue
                    }
                    
                    it("should return the newValue") {
                        expect(actualValue) == expectedValue
                    }
                }
            }
        }
    }
}
