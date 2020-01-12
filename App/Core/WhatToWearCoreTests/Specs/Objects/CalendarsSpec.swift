import Quick
import Nimble
@testable import WhatToWearCore

internal final class CalendarsSpec: QuickSpec {
    internal override func spec() {
        describe("Calendars") {
            describe("its calendar for timeZone") {
                it("should cache used calendars") {
                    let calendars = Calendars.shared
                    
                    let first = calendars.calendar(for: .current)
                    let second = calendars.calendar(for: .current)
                    
                    expect(first) == second
                    expect(calendars.calendars.count) == 1
                }
            }
        }
    }
}
