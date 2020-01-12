import Foundation
import WhatToWearCommonCore
import WhatToWearCore
import WhatToWearModels

internal struct InputTimeViewModel {
    // MARK: properties
    private let timeRows: NonEmptyArray<MilitaryTimeViewModel>

    internal let initialRow: Int

    // MARK: computed properties
    internal var numberOfRows: Int {
        return timeRows.count
    }

    // MARK: init
    internal init(time: MilitaryTime) {
        let times = NonEmptyArray(range: 0...23)
            .map { MilitaryTime(hour: $0, minute: 0) }
            .byAppending(MilitaryTime.endOfDay)
        
        self.timeRows = times.map { MilitaryTimeViewModel(time: $0, timeZone: .current) }
        self.initialRow = Self.indexOfNearestTime(to: time, in: times)
    }

    // MARK: init helpers
    private static func indexOfNearestTime(to time: MilitaryTime, in times: NonEmptyArray<MilitaryTime>) -> Int {
        var nearestIndex = 0

        for (index, comparisonTime) in times.enumerated() {
            let delta = abs(time.minutesSince(comparisonTime))
            let nearestDelta = abs(time.minutesSince(times[nearestIndex]))

            if delta < nearestDelta {
                nearestIndex = index

                if delta == 0 {
                    break
                }
            }
        }

        return nearestIndex
    }

    // MARK: retrieving times
    internal func viewModel(forRow row: Int) -> MilitaryTimeViewModel {
        return timeRows[row]
    }
}
