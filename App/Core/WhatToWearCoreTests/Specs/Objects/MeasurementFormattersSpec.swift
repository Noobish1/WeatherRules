import Quick
import Nimble
@testable import WhatToWearCore

internal final class MeasurementFormattersSpec: QuickSpec {
    internal override func spec() {
        describe("MeasurementFormatters") {
            describe("its measurementFormatter") {
                var actual: String!
                var expected: String!
                
                beforeEach {
                    let measurement = Measurement(value: 5, unit: UnitSpeed.kilometersPerHour)
                    
                    actual = MeasurementFormatters.measurementFormatter.string(from: measurement)
                    expected = "5km/h"
                }
                
                it("should format measurements correctly") {
                    expect(actual) == expected
                }
            }
            
            describe("its unitFormatter") {
                var actual: String!
                var expected: String!
                
                beforeEach {
                    let unit = UnitSpeed.kilometersPerHour
                    
                    actual = MeasurementFormatters.unitFormatter.string(from: unit)
                    expected = "km/hr"
                }
                
                it("should format units correctly") {
                    expect(actual) == expected
                }
            }
        }
    }
}
