import Foundation

internal struct DrawableChartEntry {
    internal let point: CGPoint
    internal let entry: CGPoint

    internal init<T>(entry: CGPoint, dataSet: T, dataProvider: DataProvider<T>) {
        let transformer = dataProvider.transformer(forAxis: dataSet.axisDependency)

        self.point = entry.applying(transformer.valueToPixelMatrix)
        self.entry = entry
    }
}
