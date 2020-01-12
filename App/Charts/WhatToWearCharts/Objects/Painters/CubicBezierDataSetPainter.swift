import Foundation

internal enum CubicBezierDataSetPainter: LineDataSetPainterProtocol {
    internal static func drawCubicBezier(
        context: CGContext,
        dataSet: LineChartDataSet,
        color: UIColor,
        dataProvider: DataProvider<LineChartDataSet>
    ) {
        let transformer = dataProvider.transformer(forAxis: dataSet.axisDependency)
        let intensity = dataSet.lineConfig.cubicIntensity
        let cubicPath = CGMutablePath()

        let yRange = dataProvider.axisRange(forDataSet: dataSet)

        var values = dataSet.values
        values.insert(values.first, at: 0)
        values.append(values.last)

        cubicPath.move(to: values.first, transform: transformer.valueToPixelMatrix)

        for i in 0...(values.count - 4) {
            let first = values[i]
            let second = values[i + 1]
            let third = values[i + 2]
            let fourth = values[i + 3]

            let prevDx = (third.x - first.x) * intensity
            let prevDy = (third.y - first.y) * intensity
            let curDx = (fourth.x - second.x) * intensity
            let curDy = (fourth.y - second.y) * intensity

            cubicPath.addCurve(
                to: third,
                control1: CGPoint(x: second.x + prevDx, y: (second.y + prevDy).clamped(to: yRange)),
                control2: CGPoint(x: third.x - curDx, y: (third.y - curDy).clamped(to: yRange)),
                transform: transformer.valueToPixelMatrix
            )
        }

        context.saveGState()

        if let fillConfig = dataSet.fillConfig {
            // Copy this path because we make changes to it

            // swiftlint:disable force_unwrapping
            let fillPath = cubicPath.mutableCopy()!
            // swiftlint:enable force_unwrapping

            drawCubicFill(
                context: context,
                dataSet: dataSet,
                fillConfig: fillConfig,
                spline: fillPath,
                matrix: transformer.valueToPixelMatrix,
                dataProvider: dataProvider
            )
        }

        context.beginPath()
        context.addPath(cubicPath)
        context.setStrokeColor(color.cgColor)
        context.strokePath()

        context.restoreGState()
    }

    private static func drawCubicFill(
        context: CGContext,
        dataSet: LineChartDataSet,
        fillConfig: LineChartDataSet.FillConfig,
        spline: CGMutablePath,
        matrix: CGAffineTransform,
        dataProvider: DataProvider<LineChartDataSet>
    ) {
        let fillMin = fillConfig.formatter.fillLinePosition(
            dataSet: dataSet, dataProvider: dataProvider
        )

        let pt1 = CGPoint(x: dataSet.values.last.x, y: fillMin).applying(matrix)
        let pt2 = CGPoint(x: dataSet.values.first.x, y: fillMin).applying(matrix)

        spline.addLine(to: pt1)
        spline.addLine(to: pt2)
        spline.closeSubpath()

        drawFilledPath(
            context: context,
            path: spline,
            fillConfig: fillConfig,
            dataProvider: dataProvider
        )
    }
}
