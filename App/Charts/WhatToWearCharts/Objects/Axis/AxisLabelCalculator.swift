import Foundation
import WhatToWearCommonCore

public enum AxisLabelCalculator {
    // MARK: static label calculation functions
    public static func yAxisLabelOffset(
        config: LabelConfig,
        position: YAxis.LabelPosition,
        entries: NonEmptyArray<CGFloat>,
        valueFormatter: AxisValueFormatterProtocol,
        offset: UIOffset
    ) -> CGFloat {
        guard config.enabled && position == .outsideChart else {
            return 0
        }
        
        return AxisLabelCalculator.widthForLongestLabel(
            config: config,
            entries: entries,
            using: valueFormatter,
            offset: offset
        )
    }
    
    public static func widthForLongestLabel(
        config: LabelConfig,
        entries: NonEmptyArray<CGFloat>,
        using valueFormatter: AxisValueFormatterProtocol,
        offset: UIOffset
    ) -> CGFloat {
        let longLabel = longestlabel(in: entries, using: valueFormatter)
        let size = (longLabel as NSString).size(withAttributes: [.font: config.font])

        return min(size.width + (offset.horizontal * 2.0), 9999)
    }
    
    public static func longestlabel(
        in entries: NonEmptyArray<CGFloat>,
        using valueFormatter: AxisValueFormatterProtocol
    ) -> String {
        return entries
            .map { formattedLabel(forEntry: $0, using: valueFormatter) }
            .max(by: { $0.count > $1.count })
    }
    
    public static func formattedLabel(
        forEntry entry: CGFloat,
        using valueFormatter: AxisValueFormatterProtocol
    ) -> String {
        return valueFormatter.stringForValue(entry)
    }
}
