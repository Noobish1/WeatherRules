import Quick
import Nimble
@testable import WhatToWearModels
@testable import WeatherRules

internal final class UnitMeasurementViewModelSpec: QuickSpec {
    internal override func spec() {
        describe("UnitMeasurementViewModel") {
            describe("its displayedUnitSymbolString") {
                var measurement: UnitMeasurement<UnitTemperature>!
                
                beforeEach {
                    measurement = UnitMeasurement(
                        id: .feelsLikeTemperature,
                        value: .hourly({ $0.apparentTemperature }),
                        name: NSLocalizedString("'Feels-like' Temperature", comment: ""),
                        explanation: NSLocalizedString("The 'feels like' temperature.", comment: ""),
                        rawRange: -Double.infinity...Double.infinity,
                        rawUnit: .celsius,
                        displayedMetricUnit: .celsius,
                        displayedImperialUnit: .fahrenheit
                    )
                }
                
                context("when the system is metric") {
                    var symbol: String!
                    
                    beforeEach {
                        symbol = UnitMeasurementViewModel.displayedUnitSymbolString(for: measurement, system: .metric)
                    }
                    
                    it("should return the correct symbol") {
                        expect(symbol) == "°C"
                    }
                }
                
                context("when the system is imperial") {
                    var symbol: String!
                    
                    beforeEach {
                        symbol = UnitMeasurementViewModel.displayedUnitSymbolString(for: measurement, system: .imperial)
                    }
                    
                    it("should return the correct symbol") {
                        expect(symbol) == "°F"
                    }
                }
            }
            
            describe("its title") {
                var actualTitle: String!
                var expectedTitle: String!
                
                beforeEach {
                    let measurement = UnitMeasurement(
                        id: .feelsLikeTemperature,
                        value: .hourly({ $0.apparentTemperature }),
                        name: NSLocalizedString("'Feels-like' Temperature", comment: ""),
                        explanation: NSLocalizedString("The 'feels like' temperature.", comment: ""),
                        rawRange: -Double.infinity...Double.infinity,
                        rawUnit: .celsius,
                        displayedMetricUnit: .celsius,
                        displayedImperialUnit: .fahrenheit
                    )
                    
                    actualTitle = UnitMeasurementViewModel.title(for: measurement, system: .metric)
                    expectedTitle = "\(measurement.name) (°C)"
                }
                
                it("should return the correct title for the given measurement and system") {
                    expect(actualTitle) == expectedTitle
                }
            }
            
            describe("its displayedStringValueWithUnits") {
                var actualString: String!
                var expectedString: String!
                
                beforeEach {
                    let measurement = UnitMeasurement(
                        id: .feelsLikeTemperature,
                        value: .hourly({ $0.apparentTemperature }),
                        name: NSLocalizedString("'Feels-like' Temperature", comment: ""),
                        explanation: NSLocalizedString("The 'feels like' temperature.", comment: ""),
                        rawRange: -Double.infinity...Double.infinity,
                        rawUnit: .celsius,
                        displayedMetricUnit: .celsius,
                        displayedImperialUnit: .fahrenheit
                    )
                    
                    expectedString = "10°C"
                    actualString = UnitMeasurementViewModel.displayedStringValueWithUnits(for: measurement, rawValue: 10, system: .metric)
                }
                
                it("should return the correct string") {
                    expect(actualString) == expectedString
                }
            }
            
            describe("its displayedMeasurement") {
                var measurement: UnitMeasurement<UnitTemperature>!
                
                beforeEach {
                    measurement = UnitMeasurement(
                        id: .feelsLikeTemperature,
                        value: .hourly({ $0.apparentTemperature }),
                        name: NSLocalizedString("'Feels-like' Temperature", comment: ""),
                        explanation: NSLocalizedString("The 'feels like' temperature.", comment: ""),
                        rawRange: -Double.infinity...Double.infinity,
                        rawUnit: .celsius,
                        displayedMetricUnit: .celsius,
                        displayedImperialUnit: .fahrenheit
                    )
                }
                
                context("when the given system is metric") {
                    var actualMeasurement: Measurement<UnitTemperature>!
                    var expectedMeasurement: Measurement<UnitTemperature>!
                    
                    beforeEach {
                        let rawValue: Double = 10
                        
                        expectedMeasurement = Measurement(value: rawValue, unit: .celsius)
                        actualMeasurement = UnitMeasurementViewModel.displayedMeasurement(for: measurement, rawValue: rawValue, system: .metric)
                    }
                    
                    it("should return the correct measurement") {
                        expect(actualMeasurement) == expectedMeasurement
                    }
                }
                
                context("when the given system is imperial") {
                    var actualMeasurement: Measurement<UnitTemperature>!
                    var expectedMeasurement: Measurement<UnitTemperature>!
                    
                    beforeEach {
                        let rawValue: Double = 10
                        
                        expectedMeasurement = Measurement(value: rawValue, unit: .celsius)
                        actualMeasurement = UnitMeasurementViewModel.displayedMeasurement(for: measurement, rawValue: rawValue, system: .imperial)
                    }
                    
                    it("should return the correct measurement") {
                        expect(actualMeasurement) == expectedMeasurement
                    }
                }
            }
        }
    }
}
