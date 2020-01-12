import Foundation

// MARK: ChartPainterProtocol
public protocol ChartPainterProtocol {
    associatedtype DataSet: ChartDataSetProtocol

    static func draw(dataSet: DataSet, context: CGContext, dataProvider: DataProvider<DataSet>)
}

// MARK: Extensions
extension ChartPainterProtocol {
    public static func drawDataAndValues(context: CGContext, dataProvider: DataProvider<DataSet>) {
        drawData(context: context, dataProvider: dataProvider)
        drawValues(context: context, dataProvider: dataProvider)
    }

    public static func drawData(context: CGContext, dataProvider: DataProvider<DataSet>) {
        for set in dataProvider.dataSets where set.isVisible {
            draw(dataSet: set, context: context, dataProvider: dataProvider)
        }
    }

    public static func drawValues(context: CGContext, dataProvider: DataProvider<DataSet>) {
        for dataSet in dataProvider.drawableDataSets {
            for drawable in dataSet.drawableEntries {
                TextPainter.drawText(
                    context: context,
                    text: dataSet.valueConfig.formatter.string(for: drawable.entry),
                    point: CGPoint(
                        x: drawable.point.x,
                        y: dataSet.underlyingSet.drawingYPosition(
                            for: drawable.point.y, valueConfig: dataSet.valueConfig
                        )
                    ),
                    align: .center,
                    attributes: [
                        .font: dataSet.valueConfig.font,
                        .foregroundColor: dataSet.valueConfig.textColorConfig.color(for: drawable.entry),
                        .shadow: dataSet.valueConfig.shadow
                    ]
                )
            }
        }
    }
}
