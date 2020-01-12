import Foundation
import WhatToWearCommonCore
import WhatToWearCore

public final class DataProvider<DataSet: ChartDataSetProtocol> {
    // MARK: properties
    private let leftAxisTransformer: Transformer
    private let rightAxisTransformer: Transformer

    internal let leftAxis: YAxis
    internal let rightAxis: YAxis
    internal let xAxis: XAxis
    internal let viewPortHandler: ViewPortHandler

    public let dataSets: NonEmptyArray<DataSet>

    // MARK: computed properties
    public var chartYMax: CGFloat {
        return max(leftAxis.range.upperBound, rightAxis.range.upperBound)
    }

    public var chartYMin: CGFloat {
        return min(leftAxis.range.lowerBound, rightAxis.range.lowerBound)
    }

    internal var drawableDataSets: [DrawableDataSet<DataSet>] {
        return dataSets.compactMap { dataSet in
            DrawableDataSet(dataSet: dataSet, dataProvider: self)
        }
    }

    // MARK: init
    internal init(
        dataSets: NonEmptyArray<DataSet>,
        leftAxis: YAxis,
        rightAxis: YAxis,
        xAxis: XAxis,
        viewPortHandler: ViewPortHandler
    ) {
        self.dataSets = dataSets
        self.leftAxis = leftAxis
        self.rightAxis = rightAxis
        self.xAxis = xAxis
        self.viewPortHandler = viewPortHandler
        self.leftAxisTransformer = Transformer()
        self.rightAxisTransformer = Transformer()
    }

    private init(
        dataSets: NonEmptyArray<DataSet>,
        leftAxis: YAxis,
        rightAxis: YAxis,
        xAxis: XAxis,
        viewPortHandler: ViewPortHandler,
        leftAxisTransformer: Transformer,
        rightAxisTransformer: Transformer
    ) {
        self.dataSets = dataSets
        self.leftAxis = leftAxis
        self.rightAxis = rightAxis
        self.xAxis = xAxis
        self.viewPortHandler = viewPortHandler
        self.leftAxisTransformer = leftAxisTransformer
        self.rightAxisTransformer = rightAxisTransformer
    }

    // MARK: conversion
    internal func convertToDataProvider<T: ChartDataSetProtocol>(
        for dataSet: T
    ) -> DataProvider<T> {
        return DataProvider<T>(
            dataSets: NonEmptyArray(elements: dataSet),
            leftAxis: leftAxis,
            rightAxis: rightAxis,
            xAxis: xAxis,
            viewPortHandler: viewPortHandler,
            leftAxisTransformer: leftAxisTransformer,
            rightAxisTransformer: rightAxisTransformer
        )
    }

    // MARK: retrieiving properties for axis
    internal func transformer(forAxis axis: YAxis.Dependency) -> Transformer {
        switch axis {
            case .left: return leftAxisTransformer
            case .right: return rightAxisTransformer
        }
    }

    public func axisRange(forDataSet dataSet: DataSet) -> ClosedRange<CGFloat> {
        switch dataSet.axisDependency {
            case .left: return leftAxis.range
            case .right: return rightAxis.range
        }
    }

    // MARK: preparations
    private func prepareTransformerValuePxMatrix() {
        rightAxisTransformer.prepareMatrixValuePx(
            xAxis: xAxis, yAxis: rightAxis, viewPortHandler: viewPortHandler
        )
        leftAxisTransformer.prepareMatrixValuePx(
            xAxis: xAxis, yAxis: leftAxis, viewPortHandler: viewPortHandler
        )
    }

    private func prepareTransformerOffsetMatrix() {
        rightAxisTransformer.prepareMatrixOffset(using: viewPortHandler)
        leftAxisTransformer.prepareMatrixOffset(using: viewPortHandler)
    }

    // MARK: calculations
    internal func calculateOffsets() {
        viewPortHandler.restrainViewPort(xAxis: xAxis, leftAxis: leftAxis, rightAxis: rightAxis)

        prepareTransformerOffsetMatrix()
        prepareTransformerValuePxMatrix()
    }
}
