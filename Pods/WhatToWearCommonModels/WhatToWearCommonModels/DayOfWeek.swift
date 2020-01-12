import Foundation
import WhatToWearCommonCore

// MARK: DayOfWeek
public enum DayOfWeek: Int, Codable, CaseIterable {
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1

    public init(date: Date) {
        let calendar = Calendar(identifier: .gregorian)

        let weekDay = calendar.component(.weekday, from: date)

        // I can't find any way of making this fatalError
        // swiftlint:disable force_unwrapping
        let dayOfWeek = DayOfWeek(rawValue: weekDay)!
        // swiftlint:enable force_unwrapping

        self = dayOfWeek
    }
}
