import Foundation
import WhatToWearCommonCore
import WhatToWearCore

internal enum LinearDataSetPainter: LineDataSetPainterProtocol {
    // MARK: Line
    private struct Line {
        fileprivate let start: CGPoint
        fileprivate let end: CGPoint

        fileprivate var points: [CGPoint] {
            return [start, end]
        }

        fileprivate init(start: CGPoint, end: CGPoint?, matrix: CGAffineTransform) {
            let ourStart = start.applying(matrix)

            self.start = ourStart
            self.end = end.map { $0.applying(matrix) } ?? ourStart
        }
    }

    internal static func drawLinear(
        context: CGContext,
        dataSet: LineChartDataSet,
        colors: NonEmptyArray<UIColor>,
        dataProvider: DataProvider<LineChartDataSet>
    ) {
        let transformer = dataProvider.transformer(forAxis: dataSet.axisDependency)
        let valueToPixelMatrix = transformer.valueToPixelMatrix

        if let fillConfig = dataSet.fillConfig {
            drawLinearFill(
                context: context,
                dataSet: dataSet,
                fillConfig: fillConfig,
                transformer: transformer,
                dataProvider: dataProvider
            )
        }

        context.saveGState()
        context.setLineCap(dataSet.lineConfig.capType)

        for (i, point) in dataSet.values.enumerated() {
            let next = dataSet.values[safe: i + 1]
            let line = Line(start: point, end: next, matrix: valueToPixelMatrix)

            context.setStrokeColor(colors[i].cgColor)
            context.strokeLineSegments(between: line.points)
        }

        context.restoreGState()
    }

    private static func drawLinearFill(
        context: CGContext,
        dataSet: LineChartDataSet,
        fillConfig: LineChartDataSet.FillConfig,
        transformer: Transformer,
        dataProvider: DataProvider<LineChartDataSet>
    ) {
        let filled = generateFilledPath(
            dataSet: dataSet,
            fillMin: fillConfig.formatter.fillLinePosition(
                dataSet: dataSet,
                dataProvider: dataProvider
            ),
            matrix: transformer.valueToPixelMatrix
        )

        drawFilledPath(
            context: context,
            path: filled,
            fillConfig: fillConfig,
            dataProvider: dataProvider
        )
    }

    private static func generateFilledPath(
        dataSet: LineChartDataSet, fillMin: CGFloat, matrix: CGAffineTransform
    ) -> CGPath {
        let filled = CGMutablePath()

        for (i, point) in dataSet.values.enumerated() {
            if i == 0 {
                filled.move(to: CGPoint(x: point.x, y: fillMin), transform: matrix)
                filled.addLine(to: point, transform: matrix)
            } else if i == dataSet.values.count - 1 {
                filled.addLine(to: CGPoint(x: point.x, y: fillMin), transform: matrix)
                filled.closeSubpath()
            } else {
                filled.addLine(to: point, transform: matrix)
            }
        }

        return filled
    }
}
