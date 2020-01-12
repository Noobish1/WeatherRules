import Foundation
import WhatToWearCharts
import WhatToWearCommonCore
import WhatToWearCore
import WhatToWearModels

internal enum WeatherYAxisFactory: AxisFactoryProtocol {
    // MARK: LabelOffsets
    internal struct LabelOffsetResults {
        internal let leftAxisResult: LabelOffsetResult
        internal let rightAxisResult: LabelOffsetResult
    }
    
    // MARK: LabelOffsetResult
    internal struct LabelOffsetResult: Withable {
        internal let labelConfig: LabelConfig
        internal let valueFormatter: AxisValueFormatterProtocol
        internal let entries: NonEmptyArray<CGFloat>
        internal var labelOffset: CGFloat
        internal let gridConfig: GridConfig
        internal let dependency: YAxis.Dependency
    }
    
    // MARK: static properties
    private static let offset = UIOffset(horizontal: 8, vertical: -4)
    private static let labelPosition = YAxis.LabelPosition.outsideChart
    private static let labelCount = 4
    
    // MARK: Axis calculations
    internal static func fixLabelOffsetsIn(
        topResults: LabelOffsetResults, bottomResults: LabelOffsetResults
    ) -> (LabelOffsetResults, LabelOffsetResults) {
        let topLeft = topResults.leftAxisResult.labelOffset
        let bottomLeft = bottomResults.leftAxisResult.labelOffset
        
        let leftMax = max(topLeft, bottomLeft)
        
        let topRight = topResults.rightAxisResult.labelOffset
        let bottomRight = bottomResults.rightAxisResult.labelOffset
        
        let rightMax = max(topRight, bottomRight)
        
        let newTopResults = WeatherYAxisFactory.LabelOffsetResults(
            leftAxisResult: topResults.leftAxisResult.with(\.labelOffset, value: leftMax),
            rightAxisResult: topResults.rightAxisResult.with(\.labelOffset, value: rightMax)
        )
        
        let newBottomResults = WeatherYAxisFactory.LabelOffsetResults(
            leftAxisResult: bottomResults.leftAxisResult.with(\.labelOffset, value: leftMax),
            rightAxisResult: bottomResults.rightAxisResult.with(\.labelOffset, value: rightMax)
        )
        
        return (newTopResults, newBottomResults)
    }
    
    // MARK: label widths
    internal static func calcLabelOffsets(
        chartParams: WeatherChartView.Params,
        context: WeatherChartView.Context,
        position: WeatherChartView.Position
    ) -> LabelOffsetResults {
        let combinedData = WeatherCombinedChartData(
            chartParams: chartParams, context: context
        )
        
        return LabelOffsetResults(
            leftAxisResult: calcLabelOffset(
                labelCount: labelCount,
                combinedData: combinedData,
                chartParams: chartParams,
                dependency: .left,
                context: context,
                position: position
            ),
            rightAxisResult: calcLabelOffset(
                labelCount: labelCount,
                combinedData: combinedData,
                chartParams: chartParams,
                dependency: .right,
                context: context,
                position: position
            )
        )
    }
    
    internal static func calcLabelOffset(
        labelCount: Int,
        combinedData: WeatherCombinedChartData,
        chartParams: WeatherChartView.Params,
        dependency: YAxis.Dependency,
        context: WeatherChartView.Context,
        position: WeatherChartView.Position
    ) -> LabelOffsetResult {
        let shouldShowLabels = Self.shouldShowAxisLabels(for: position, dependency: dependency, componentsToShow: chartParams.componentsToShow)
        let valueFormatter = Self.valueFormatter(for: position, dependency: dependency, chartParams: chartParams)
        let range = Self.range(for: position, dependency: dependency, data: combinedData)
        let entries = makeEntries(range: range, labelCount: labelCount)
        
        let labelConfig = makeLabelConfig(
            context: context,
            labelCount: labelCount,
            enabled: shouldShowLabels
        )
        
        let labelOffset = AxisLabelCalculator.yAxisLabelOffset(
            config: labelConfig,
            position: labelPosition,
            entries: entries,
            valueFormatter: valueFormatter,
            offset: offset
        )
        
        return LabelOffsetResult(
            labelConfig: labelConfig,
            valueFormatter: valueFormatter,
            entries: entries,
            labelOffset: labelOffset,
            gridConfig: GridConfig(linesEnabled: chartParams.showGrid),
            dependency: dependency
        )
    }
    
    // MARK: static init helpers
    private static func makeEntries(
        range: ClosedRange<CGFloat>, labelCount: Int
    ) -> NonEmptyArray<CGFloat> {
        let numberOfGaps = CGFloat(labelCount - 1)
        let interval = (range.upperBound - range.lowerBound) / numberOfGaps
        
        if range.lowerBound == range.upperBound {
            return NonEmptyArray(elements: range.lowerBound, range.upperBound)
        } else {
            return NonEmptyArray(stride: stride(
                from: range.lowerBound,
                to: range.upperBound,
                by: interval
            )).byAppending(range.upperBound)
        }
    }
    
    private static func makeLabelConfig(
        context: WeatherChartView.Context,
        labelCount: Int,
        enabled: Bool
    ) -> LabelConfig {
        return LabelConfig(
            font: .systemFont(ofSize: labelFontSize(for: context)),
            textColor: .white,
            count: labelCount,
            enabled: enabled,
            forceLabels: true
        )
    }
    
    private static func range(
        for position: WeatherChartView.Position,
        dependency: YAxis.Dependency,
        data: WeatherCombinedChartData
    ) -> ClosedRange<CGFloat> {
        switch (position, dependency) {
            case (.top, .left): return data.windRange
            case (.top, .right), (.bottom, .right): return 0...1
            case (.bottom, .left): return data.temperatureRange
        }
    }
    
    private static func valueFormatter(
        for position: WeatherChartView.Position,
        dependency: YAxis.Dependency,
        chartParams: WeatherChartView.Params
    ) -> AxisValueFormatterProtocol {
        let system = chartParams.settings.measurementSystem
        
        switch (position, dependency) {
            case (.top, .left):
                return WindAxisFormatter(system: system)
            case (.top, .right), (.bottom, .right):
                return PercentageValueAxisFormatter()
            case (.bottom, .left):
                return TemperatureAxisFormatter(system: system)
        }
    }
    
    private static func componentsRequiringAxisLabels(
        for position: WeatherChartView.Position,
        dependency: YAxis.Dependency
    ) -> NonEmptyArray<WeatherChartComponent> {
        switch (position, dependency) {
            case (.top, .left): return NonEmptyArray(elements: .windGust, .windDirection)
            case (.top, .right): return NonEmptyArray(elements: .cloudCover, .humidity)
            case (.bottom, .left): return NonEmptyArray(elements: .temperature)
            case (.bottom, .right): return NonEmptyArray(elements: .chanceOfPrecip)
        }
    }
    
    internal static func shouldShowAxisLabels(
        for position: WeatherChartView.Position,
        dependency: YAxis.Dependency,
        componentsToShow: Set<WeatherChartComponent>
    ) -> Bool {
        let components = componentsRequiringAxisLabels(for: position, dependency: dependency)
        
        return !componentsToShow.isDisjoint(with: components)
    }
    
    internal static func makeYAxis(labelOffsetResult: LabelOffsetResult) -> YAxis {
        return YAxis(
            entries: labelOffsetResult.entries,
            labelConfig: labelOffsetResult.labelConfig,
            labelOffset: labelOffsetResult.labelOffset,
            gridConfig: labelOffsetResult.gridConfig,
            offset: offset,
            valueFormatter: labelOffsetResult.valueFormatter,
            labelPosition: labelPosition,
            dependency: labelOffsetResult.dependency
        )
    }
}
