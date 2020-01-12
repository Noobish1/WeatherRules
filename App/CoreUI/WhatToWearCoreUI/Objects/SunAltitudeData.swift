import Foundation
import WhatToWearCharts
import WhatToWearCommonCore
import WhatToWearCommonModels
import WhatToWearCore
import WhatToWearModels

internal struct SunAltitudeData {
    // MARK: properties
    internal let entries: NonEmptyArray<CGPoint>
    internal let maxSunAltitudeIndex: Int

    // MARK: init
    internal init(
        dataPoints: NonEmptyArray<HourlyDataPoint>,
        location: ValidLocation
    ) {
        let times = dataPoints.map { $0.time + 30.minutes }
        let sunAltitudeTimeAndValues = times.map {
            ($0, SunCalculator.sunAltitude(date: $0, location: location.coordinate))
        }
        let sunAltitudeValues = sunAltitudeTimeAndValues.map { $0.1 }
        let sunAltitudeRange = sunAltitudeValues.min()...sunAltitudeValues.max()

        self.maxSunAltitudeIndex = sunAltitudeValues.maxIndex()
        self.entries = sunAltitudeTimeAndValues.map { tuple -> CGPoint in
            let (time, sunAltitude) = tuple

            let normalizedAltitude = Normalizer.normalize(
                value: sunAltitude, fromRange: sunAltitudeRange, toRange: 0...1
            )

            return CGPoint(x: CGFloat(time.timeIntervalSince1970), y: normalizedAltitude)
        }
    }
}
