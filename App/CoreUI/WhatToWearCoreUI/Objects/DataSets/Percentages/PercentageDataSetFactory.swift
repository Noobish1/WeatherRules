import Foundation
import WhatToWearCharts
import WhatToWearCommonCore
import WhatToWearCommonModels
import WhatToWearCore
import WhatToWearModels

internal enum PercentageDataSetFactory {
    // MARK: init
    internal static func makeDataSet(
        dataPoints: NonEmptyArray<HourlyDataPoint>,
        axisDependency: YAxis.Dependency,
        lineConfig: LineChartDataSet.LineConfig,
        fillConfig: LineChartDataSet.FillConfig?,
        keypath: KeyPath<HourlyDataPoint, Percentage<Double>?>,
        flipped: Bool,
        isVisible: Bool
    ) -> LineChartDataSet? {
        guard let nonEmptyArray = NonEmptyArray(array: dataPoints.compactMap {
            ValidChartValue(data: $0, keyPath: keypath)
        }) else {
            return nil
        }

        let entries = nonEmptyArray.map { validValue in
            PercentageDataEntryFactory.makeEntry(
                chartValue: validValue,
                flipped: flipped
            )
        }

        return LineChartDataSet(
            values: entries,
            axisDependency: axisDependency,
            isVisible: isVisible,
            lineConfig: lineConfig,
            fillConfig: fillConfig
        )
    }
}
