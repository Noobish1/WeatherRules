import Foundation
import SnapKit
import WhatToWearCharts
import WhatToWearCore
import WhatToWearModels

public final class WeatherChartView: CodeBackedView {
    // MARK: Position
    public enum Position {
        case top
        case bottom
    }
    
    // MARK: Context
    public enum Context {
        case mainApp
        case todayExtension
        case legend
    }

    // MARK: Params
    public struct Params: Withable {
        // MARK: properties
        public let day: Date
        public let currentTime: Date
        public let forecast: TimedForecast
        public let location: ValidLocation
        public let settings: GlobalSettings
        public var componentsToShow: Set<WeatherChartComponent>
        public let showGrid = true

        // MARK: init
        public init(
            day: Date,
            currentTime: Date,
            forecast: TimedForecast,
            location: ValidLocation,
            settings: GlobalSettings
        ) {
            self.day = day
            self.currentTime = currentTime
            self.forecast = forecast
            self.location = location
            self.settings = settings
            self.componentsToShow = settings.shownComponentsSet
        }
    }

    // MARK: init
    public init(params: Params, context: Context) {
        let (topChart, bottomChart) = type(of: self).makeTopAndBottomCharts(
            params: params, context: context
        )

        super.init(frame: UIScreen.main.bounds)

        self.clipsToBounds = false
        self.isUserInteractionEnabled = false

        setupViews(topChart: topChart, bottomChart: bottomChart)
    }

    // MARK: static init helpers
    private static func makeTopAndBottomCharts(params: Params, context: Context) -> (CombinedChartView?, CombinedChartView?) {
        let topComponentsToShow = params.componentsToShow.subtracting(WeatherChartComponent.componentsOnlyOnTheBottomChart)
        let makeTopChart = !topComponentsToShow.isEmpty && topComponentsToShow != [.currentTime]
        
        let bottomComponentsToShow = params.componentsToShow.subtracting(WeatherChartComponent.componentsOnlyOnTheTopChart)
        let makeBottomChart = !bottomComponentsToShow.isEmpty && bottomComponentsToShow != [.currentTime]

        let topParams = params.with(\.componentsToShow, value: topComponentsToShow)
        
        let topOffsetResults = WeatherYAxisFactory.calcLabelOffsets(
            chartParams: topParams, context: context, position: .top
        )
        
        let bottomParams = params.with(\.componentsToShow, value: bottomComponentsToShow)
        
        let bottomOffsetResults = WeatherYAxisFactory.calcLabelOffsets(
            chartParams: bottomParams, context: context, position: .bottom
        )
        
        if makeTopChart && makeBottomChart {
            let (finalTopOffsetResults, finalBottomOffsetResults) = WeatherYAxisFactory.fixLabelOffsetsIn(
                topResults: topOffsetResults,
                bottomResults: bottomOffsetResults
            )
            
            let topChart = CombinedWeatherChartViewFactory.makeChartView(
                params: topParams,
                labelOffsetResults: finalTopOffsetResults,
                context: context,
                position: .top,
                isOnlyChart: false
            )
            
            let bottomChart = CombinedWeatherChartViewFactory.makeChartView(
                params: bottomParams,
                labelOffsetResults: finalBottomOffsetResults,
                context: context,
                position: .bottom,
                isOnlyChart: false
            )
            
            return (topChart, bottomChart)
        } else if makeTopChart {
            let topChart = CombinedWeatherChartViewFactory.makeChartView(
                params: topParams,
                labelOffsetResults: topOffsetResults,
                context: context,
                position: .top,
                isOnlyChart: true
            )
            
            return (topChart, nil)
        } else {
            let bottomChart = CombinedWeatherChartViewFactory.makeChartView(
                params: bottomParams,
                labelOffsetResults: bottomOffsetResults,
                context: context,
                position: .bottom,
                isOnlyChart: true
            )
            
            return (nil, bottomChart)
        }
    }
    
    // MARK: setup
    private func setupViews(topChart: CombinedChartView?, bottomChart: CombinedChartView?) {
        if let topChart = topChart, let bottomChart = bottomChart {
            add(subview: topChart, withConstraints: { make in
                make.top.equalToSuperview()
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
            })
            
            add(subview: bottomChart, withConstraints: { make in
                make.top.equalTo(topChart.snp.bottom)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalTo(topChart).multipliedBy(0.7)
            })
        } else if let topChart = topChart, bottomChart == nil {
            add(fullscreenSubview: topChart)
        } else if let bottomChart = bottomChart, topChart == nil {
            add(fullscreenSubview: bottomChart)
        }
    }
}
