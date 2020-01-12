import Foundation
import WhatToWearCommonCore
import WhatToWearCore

internal struct DrawableDataSet<DataSet: ChartDataSetProtocol> {
    internal let drawableEntries: NonEmptyArray<DrawableChartEntry>
    internal let valueConfig: ValueConfig
    internal let underlyingSet: DataSet

    internal init?(dataSet: DataSet, dataProvider: DataProvider<DataSet>) {
        guard dataSet.isVisible, let valueConfig = dataSet.valueConfig else {
            return nil
        }

        let entries = dataSet.values.map { entry in
            DrawableChartEntry(
                entry: entry, dataSet: dataSet, dataProvider: dataProvider
            )
        }

        self.drawableEntries = entries
        self.valueConfig = valueConfig
        self.underlyingSet = dataSet
    }
}
