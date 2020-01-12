import Foundation
import WhatToWearCore

public enum LineChartPainter: ChartPainterProtocol {
    // MARK: drawing
    public static func draw(
        dataSet: LineChartDataSet, context: CGContext, dataProvider: DataProvider<LineChartDataSet>
    ) {
        guard dataSet.values.count >= 2 else {
            return
        }

        context.saveGState()
        context.setLineWidth(dataSet.lineConfig.width)

        // if drawing cubic lines is enabled
        switch dataSet.lineConfig.mode {
            case .linear(colors: let colors):
                LinearDataSetPainter.drawLinear(
                    context: context,
                    dataSet: dataSet,
                    colors: colors,
                    dataProvider: dataProvider
                )
            case .cubicBezier(color: let color):
                CubicBezierDataSetPainter.drawCubicBezier(
                    context: context,
                    dataSet: dataSet,
                    color: color,
                    dataProvider: dataProvider
                )
        }

        context.restoreGState()
    }
}
