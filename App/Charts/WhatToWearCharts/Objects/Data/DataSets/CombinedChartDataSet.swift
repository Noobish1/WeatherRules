import Foundation
import WhatToWearCommonCore
import WhatToWearCore

public enum CombinedChartDataSet {
    case scatter(ScatterChartDataSet)
    case line(LineChartDataSet)

    // MARK: init
    public init?(_ scatterDataSet: ScatterChartDataSet?) {
        guard let dataSet = scatterDataSet else {
            return nil
        }

        self = .scatter(dataSet)
    }

    public init?(_ lineDataSet: LineChartDataSet?) {
        guard let dataSet = lineDataSet else {
            return nil
        }

        self = .line(dataSet)
    }
}

// MARK: ChartDatasetProtocol
extension CombinedChartDataSet: ChartDataSetProtocol {
    // MARK: conversion
    internal var wrapper: ChartDataSetProtocol {
        switch self {
            case .line(let dataSet): return dataSet
            case .scatter(let dataSet): return dataSet
        }
    }

    // MARK: computed properties
    public var values: NonEmptyArray<CGPoint> {
        return wrapper.values
    }

    public var axisDependency: YAxis.Dependency {
        return wrapper.axisDependency
    }

    public var valueConfig: ValueConfig? {
        return wrapper.valueConfig
    }

    public var isVisible: Bool {
        return wrapper.isVisible
    }

    // MARK: drawing positions
    public func drawingYPosition(for yValue: CGFloat, valueConfig: ValueConfig) -> CGFloat {
        return wrapper.drawingYPosition(for: yValue, valueConfig: valueConfig)
    }
}
