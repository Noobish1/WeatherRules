import Foundation
import WhatToWearCharts
import WhatToWearCommonCore
import WhatToWearCore

internal enum TimeXAxisFactory: AxisFactoryProtocol {
    // MARK: init
    internal static func makeXAxis(
        chartParams: WeatherChartView.Params,
        context: WeatherChartView.Context,
        position: WeatherChartView.Position,
        isOnlyChart: Bool
    ) -> XAxis {
        let timeZone = chartParams.forecast.forecast.timeZone
        let calendar = Calendars.shared.calendar(for: timeZone)
        let firstDate = calendar.startOfDay(for: chartParams.day)

        let screenWidth = UIScreen.main.fixedCoordinateSpace.bounds.width
        let interval = screenWidth > 320 ? 3 : 4

        let entries = NonEmptyArray(stride: stride(from: 0, through: 24, by: interval))
            .map { firstDate + $0.hours }
            .map { CGFloat($0.timeIntervalSince1970) }

        let formatter = XAxisTimeFormatter(chartParams: chartParams)

        return XAxis(
            entries: entries,
            labelConfig: LabelConfig(
                font: .systemFont(ofSize: labelFontSize(for: context)),
                textColor: .white,
                count: entries.count,
                enabled: position == .bottom || isOnlyChart
            ),
            gridConfig: GridConfig(linesEnabled: chartParams.showGrid),
            offset: UIOffset(horizontal: 5, vertical: 5),
            valueFormatter: formatter,
            colorFormatter: formatter,
            labelPosition: .bottom
        )
    }
}
