import Foundation

internal protocol LineDataSetPainterProtocol {}

extension LineDataSetPainterProtocol {
    internal static func drawFilledPath(
        context: CGContext,
        path: CGPath,
        fillConfig: LineChartDataSet.FillConfig,
        dataProvider: DataProvider<LineChartDataSet>
    ) {
        context.saveGState()
        context.beginPath()
        context.addPath(path)

        // filled is usually drawn with less alpha
        context.setAlpha(fillConfig.alpha)

        fillConfig.type.fillPath(context: context, rect: dataProvider.viewPortHandler.contentRect)

        context.restoreGState()
    }
}
