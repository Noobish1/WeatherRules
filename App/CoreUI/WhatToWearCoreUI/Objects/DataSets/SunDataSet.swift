import CoreLocation
import Foundation
import WhatToWearCharts
import WhatToWearCommonCore
import WhatToWearCore
import WhatToWearModels

internal final class SunDataSet {
    // MARK: properties
    private let maxSunAltitudeIndex: Int
    internal let scatterDataSet: ScatterChartDataSet
    
    // MARK: init
    internal init(
        data: SunAltitudeData,
        viewModel: WeatherChartComponentViewModel,
        context: WeatherChartView.Context
    ) {
        self.maxSunAltitudeIndex = data.maxSunAltitudeIndex

        // We adjust the entries in order to push them up so the Sun is halfway above the chart
        let ourAdjustment = Self.adjustment(for: 0...1, context: context)

        let adjustedEntries = data.entries.map { entry in
            CGPoint(x: entry.x, y: entry.y + ourAdjustment)
        }

        let colors: NonEmptyArray<UIColor> = data.entries.nonEmptyIndices.map { index in
            if index == data.maxSunAltitudeIndex {
                return viewModel.color
            } else {
                return .clear
            }
        }

        self.scatterDataSet = ScatterChartDataSet(
            values: adjustedEntries,
            axisDependency: .right,
            isVisible: viewModel.isVisible,
            scatterConfig: .init(
                shapeSize: Self.shapeSize(for: context),
                shapeRenderer: SunShapeRenderer(),
                colors: colors
            )
        )
    }
    
    // MARK: shape sizes
    private static func shapeSize(for context: WeatherChartView.Context) -> CGFloat {
        switch (InterfaceIdiom.current, context) {
            case (.pad, .mainApp): return 80
            case (.pad, .legend): return 50
            case (.phone, _), (.pad, .todayExtension): return 40
        }
    }
    
    // MARK: adjustments
    private static func adjustment(
        for range: ClosedRange<CGFloat>,
        context: WeatherChartView.Context
    ) -> CGFloat {
        let interval = range.upperBound - range.lowerBound
        
        // These differ because of the different font sizes on the charts
        switch (InterfaceIdiom.current, context) {
            case (.pad, .mainApp): return interval / 54
            case (.pad, .legend): return interval / 8
            case (.phone, _), (.pad, .todayExtension): return interval / 10
        }
    }
}
