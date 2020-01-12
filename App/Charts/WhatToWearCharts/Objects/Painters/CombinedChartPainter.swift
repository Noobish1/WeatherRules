import Foundation

public enum CombinedChartPainter: ChartPainterProtocol {
    // MARK: drawing
    public static func draw(
        dataSet: CombinedChartDataSet,
        context: CGContext,
        dataProvider: DataProvider<CombinedChartDataSet>
    ) {
        switch dataSet {
            case .line(let lineDataSet):
                let lineProvider = dataProvider.convertToDataProvider(for: lineDataSet)

                LineChartPainter.draw(
                    dataSet: lineDataSet, context: context, dataProvider: lineProvider
                )
            case .scatter(let scatterDataSet):
                let scatterProvider = dataProvider.convertToDataProvider(for: scatterDataSet)

                ScatterChartPainter.draw(
                    dataSet: scatterDataSet,
                    context: context,
                    dataProvider: scatterProvider
                )
        }
    }

    public static func drawValues(
        context: CGContext, dataProvider: DataProvider<CombinedChartDataSet>
    ) {
        for set in dataProvider.dataSets {
            switch set {
                case .line(let lineDataSet):
                    let lineProvider = dataProvider.convertToDataProvider(for: lineDataSet)

                    LineChartPainter.drawValues(context: context, dataProvider: lineProvider)
                case .scatter(let scatterDataSet):
                    let scatterProvider = dataProvider.convertToDataProvider(for: scatterDataSet)

                    ScatterChartPainter.drawValues(context: context, dataProvider: scatterProvider)
            }
        }
    }
}
