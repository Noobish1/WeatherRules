import Foundation
import WhatToWearCharts
import WhatToWearCommonCore
import WhatToWearCommonModels
import WhatToWearCore
import WhatToWearModels

internal enum NowDataSetFactory {
    // MARK: init helpers
    private static func initialEntries(
        from dataPoints: NonEmptyArray<HourlyDataPoint>,
        range: ClosedRange<CGFloat>
    ) -> NonEmptyArray<CGPoint> {
        return dataPoints.map { dataPoint in
            CGPoint(
                x: CGFloat(dataPoint.time.timeIntervalSince1970),
                y: range.lowerBound
            )
        }
    }

    private static func finalEntries(
        currentTime: Date,
        from dataPoints: NonEmptyArray<HourlyDataPoint>,
        range: ClosedRange<CGFloat>,
        color: UIColor
    ) -> NonEmptyArray<NowDataEntry>? {
        let nowEntry = NowDataEntry(color: color, point: CGPoint(
            x: CGFloat(currentTime.timeIntervalSince1970),
            y: range.upperBound
        ))

        var entries = initialEntries(from: dataPoints, range: range)
            .map { point in
                NowDataEntry(color: .clear, point: point)
            }
            .byAppending(nowEntry)
            .sorted(by: { $0.point.x < $1.point.x })

        guard entries.first != nowEntry else {
            // This should only happen when we have only one entry
            // due to the fact that the first entry is always at 11pm the previous day

            return nil
        }

        guard let indexOfNow = entries.firstIndex(of: nowEntry) else {
            fatalError("Cannot find index of the element you just inserted")
        }

        let leftElement = entries[indexOfNow - 1]

        if entries.last == nowEntry && entries.count > 1 {
            guard (nowEntry.point.x - leftElement.point.x) < CGFloat(60.minutes) else {
                return nil
            }

            let adjustedLeftX = leftElement.point.x - CGFloat(10.minutes)

            let newLeftElement = NowDataEntry(color: .orange, point: CGPoint(
                x: adjustedLeftX,
                y: range.lowerBound
            ))
            let newNowElement = NowDataEntry(color: .orange, point: CGPoint(
                x: adjustedLeftX,
                y: range.upperBound
            ))

            entries.replace(leftElement, with: newLeftElement)
            entries.replace(nowEntry, with: newNowElement)

            return entries
        } else {
            let newLeftElement = NowDataEntry(
                color: color,
                point: CGPoint(x: nowEntry.point.x, y: range.lowerBound)
            )

            let rightElement = entries[indexOfNow + 1]
            let newRightElement = NowDataEntry(
                color: .clear,
                point: CGPoint(x: nowEntry.point.x, y: range.lowerBound)
            )

            entries.replace(leftElement, with: newLeftElement)
            entries.replace(rightElement, with: newRightElement)

            return entries
        }
    }

    // MARK: init/deinit
    internal static func makeDataSet(
        currentTime: Date,
        dataPoints: NonEmptyArray<HourlyDataPoint>,
        viewModel: WeatherChartComponentViewModel
    ) -> LineChartDataSet? {
        guard let entries = finalEntries(
            currentTime: currentTime,
            from: dataPoints,
            range: 0...1,
            color: viewModel.color
        ) else {
            return nil
        }

        return LineChartDataSet(
            values: entries.map { $0.point },
            axisDependency: .right,
            isVisible: viewModel.isVisible,
            lineConfig: .init(
                mode: .linear(colors: entries.map { $0.color }),
                capType: .butt,
                width: 2
            )
        )
    }
}
