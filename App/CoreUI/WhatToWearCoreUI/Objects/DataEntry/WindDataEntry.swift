import Foundation
import WhatToWearCharts
import WhatToWearCommonModels
import WhatToWearModels

internal struct WindDataEntry {
    // MARK: properties
    internal let point: CGPoint
    internal let windBearing: Double?

    // MARK: init
    internal init(dataPoint: HourlyDataPoint, windType: WindType) {
        self.init(
            time: dataPoint.time,
            windGust: dataPoint[keyPath: windType.dataPointKeyPath]?.value ?? 0,
            windBearing: dataPoint.windBearing?.value
        )
    }

    private init(time: Date, windGust: Double, windBearing: Double?) {
        let windGustInKmH = windGust * 60 * 60 / 1000

        self.windBearing = windBearing
        self.point = WeatherDataEntryFactory.makeEntry(time: time, value: CGFloat(windGustInKmH))
    }
}
