import Quick
import Nimble
@testable import WhatToWearCore

internal final class DateFormattersSpec: QuickSpec {
    internal override func spec() {
        describe("DateFormatters") {
            var formatters: DateFormatters!
            
            beforeEach {
                formatters = DateFormatters.shared
            }
            
            describe("appleReleaseDateFormatter for timeZone") {
                it("should cache the used formatter") {
                    let first = formatters.appleReleaseDateFormatter(for: .current)
                    let second = formatters.appleReleaseDateFormatter(for: .current)
                    
                    expect(first) == second
                    expect(formatters.appleReleaseDateFormatters.count) == 1
                }
            }
            
            describe("xAxisDateFormatter for timeZone") {
                it("should cache the used formatter") {
                    let first = formatters.xAxisDateFormatter(for: .current)
                    let second = formatters.xAxisDateFormatter(for: .current)
                    
                    expect(first) == second
                    expect(formatters.xAxisDateFormatters.count) == 1
                }
            }
            
            describe("hourWithSpaceFormatter for timeZone") {
                it("should cache the used formatter") {
                    let first = formatters.hourWithSpaceFormatter(for: .current)
                    let second = formatters.hourWithSpaceFormatter(for: .current)
                    
                    expect(first) == second
                    expect(formatters.hourWithSpaceFormatters.count) == 1
                }
            }
            
            describe("dayFormatter for timeZone") {
                it("should cache the used formatter") {
                    let first = formatters.dayFormatter(for: .current)
                    let second = formatters.dayFormatter(for: .current)
                    
                    expect(first) == second
                    expect(formatters.dayFormatters.count) == 1
                }
            }
        }
    }
}
