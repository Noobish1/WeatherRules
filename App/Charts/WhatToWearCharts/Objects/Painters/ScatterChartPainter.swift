import Foundation

public enum ScatterChartPainter: ChartPainterProtocol {
    // MARK: drawing
    public static func draw(
        dataSet: ScatterChartDataSet,
        context: CGContext,
        dataProvider: DataProvider<ScatterChartDataSet>
    ) {
        guard let config = dataSet.scatterConfig else {
            return
        }

        let transformer = dataProvider.transformer(forAxis: dataSet.axisDependency)

        context.saveGState()

        for (i, point) in dataSet.values.enumerated() {
            config.shapeRenderer.renderShape(
                context: context,
                config: config,
                point: point.applying(transformer.valueToPixelMatrix),
                color: config.colors[i]
            )
        }

        context.restoreGState()
    }
}
