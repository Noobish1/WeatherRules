import Foundation
import WhatToWearCharts
import WhatToWearCore
import WhatToWearModels

internal enum CombinedWeatherChartViewFactory {
    // MARK: init
    internal static func makeChartView(
        params: WeatherChartView.Params,
        labelOffsetResults: WeatherYAxisFactory.LabelOffsetResults,
        context: WeatherChartView.Context,
        position: WeatherChartView.Position,
        isOnlyChart: Bool
    ) -> CombinedChartView {
        let combinedData = WeatherCombinedChartData(
            chartParams: params, context: context
        )
        let xAxis = TimeXAxisFactory.makeXAxis(
            chartParams: params,
            context: context,
            position: position,
            isOnlyChart: isOnlyChart
        )
        let leftAxis = WeatherYAxisFactory.makeYAxis(labelOffsetResult: labelOffsetResults.leftAxisResult)
        let rightAxis = WeatherYAxisFactory.makeYAxis(labelOffsetResult: labelOffsetResults.rightAxisResult)
        let extraOffsets = Self.chartExtraOffsets(chartParams: params, position: position, context: context, isOnlyChart: isOnlyChart)
        
        return CombinedChartView(
            dataSets: combinedData.dataSets,
            xAxis: xAxis,
            leftAxis: leftAxis,
            rightAxis: rightAxis,
            extraOffsets: extraOffsets
        )
    }
    
    // MARK: offsets
    // swiftlint:disable cyclomatic_complexity
    private static func chartExtraTopOffset(
        chartParams: WeatherChartView.Params,
        position: WeatherChartView.Position,
        context: WeatherChartView.Context,
        isOnlyChart: Bool
    ) -> CGFloat {
    // swiftlint:enable cyclomatic_complexity
        let hasSun = chartParams.componentsToShow.contains(.solarNoon)
        let hasWindDirection = chartParams.componentsToShow.contains(.windDirection)
        
        switch (position, context, isOnlyChart: isOnlyChart, hasSun: hasSun, hasWindDirection: hasWindDirection) {
            case (.top, _, isOnlyChart: _, hasSun: true, hasWindDirection: _):
                switch InterfaceIdiom.current {
                    case .phone: return 42
                    case .pad: return 60
                }
            case (.top, _, isOnlyChart: _, hasSun: false, hasWindDirection: true):
                return 35
            case (.top, .legend, isOnlyChart: _, hasSun: false, hasWindDirection: false):
                return 30
            case (.top, _, isOnlyChart: _, hasSun: false, hasWindDirection: false):
                return 16
            case (.bottom, .legend, isOnlyChart: true, hasSun: _, hasWindDirection: _):
                return 30
            case (.bottom, _, isOnlyChart: true, hasSun: _, hasWindDirection: _):
                return 16
            case (.bottom, .mainApp, isOnlyChart: false, hasSun: _, hasWindDirection: _):
                switch InterfaceIdiom.current {
                    case .phone: return 0
                    case .pad: return 30
                }
            case (.bottom, _, isOnlyChart: false, hasSun: _, hasWindDirection: _):
                return 0
        }
    }
    
    private static func chartExtraHorizontalOffset(
        position: WeatherChartView.Position,
        dependency: YAxis.Dependency,
        componentsToShow: Set<WeatherChartComponent>,
        isOnlyChart: Bool,
        defaultValue: CGFloat
    ) -> CGFloat {
        let topAxisLabelsEnabled = WeatherYAxisFactory.shouldShowAxisLabels(for: .top, dependency: dependency, componentsToShow: componentsToShow)
        let bottomAxisLabelsEnabled = WeatherYAxisFactory.shouldShowAxisLabels(for: .bottom, dependency: dependency, componentsToShow: componentsToShow)
        
        switch position {
            case .top where isOnlyChart && !topAxisLabelsEnabled: return 34
            case .bottom where isOnlyChart && !bottomAxisLabelsEnabled: return 34
            case _ where !isOnlyChart && !topAxisLabelsEnabled && !bottomAxisLabelsEnabled: return 34
            default: return defaultValue
        }
    }
    
    private static func chartExtraOffsets(
        chartParams: WeatherChartView.Params,
        position: WeatherChartView.Position,
        context: WeatherChartView.Context,
        isOnlyChart: Bool
    ) -> UIEdgeInsets {
        let componentsToShow = chartParams.componentsToShow
        let topOffset = chartExtraTopOffset(chartParams: chartParams, position: position, context: context, isOnlyChart: isOnlyChart)
        let leftOffset = chartExtraHorizontalOffset(
            position: position, dependency: .left, componentsToShow: componentsToShow, isOnlyChart: isOnlyChart, defaultValue: 4
        )
        let rightOffset = chartExtraHorizontalOffset(
            position: position, dependency: .right, componentsToShow: componentsToShow, isOnlyChart: isOnlyChart, defaultValue: 12
        )
        
        return UIEdgeInsets(top: topOffset, left: leftOffset, bottom: 0, right: rightOffset)
    }
}
