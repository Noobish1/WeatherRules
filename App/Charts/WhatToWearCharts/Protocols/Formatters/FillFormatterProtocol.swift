import CoreGraphics
import Foundation

public protocol FillFormatterProtocol {
    func fillLinePosition(
        dataSet: LineChartDataSet,
        dataProvider: DataProvider<LineChartDataSet>
    ) -> CGFloat
}
