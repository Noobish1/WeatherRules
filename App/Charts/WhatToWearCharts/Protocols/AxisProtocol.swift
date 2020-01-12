import Foundation
import WhatToWearCommonCore
import WhatToWearCore

// MARK: AxisProtocol
internal protocol AxisProtocol {
    var range: ClosedRange<CGFloat> { get }
    var entries: NonEmptyArray<CGFloat> { get }
    var valueFormatter: AxisValueFormatterProtocol { get }
    var colorFormatter: AxisColorFormatterProtocol? { get }
    var offset: UIOffset { get }
    var labelConfig: LabelConfig { get }
    var gridConfig: GridConfig { get }
    var textAlignment: NSTextAlignment { get }

    func preTransformedPoint(forEntry entry: CGFloat) -> CGPoint
    func gridLines<T>(dataProvider: DataProvider<T>) -> NonEmptyArray<GridLine>
    func pointToDrawAtForEntry<T>(at index: Int, dataProvider: DataProvider<T>) -> CGPoint
    func transformer<T>(from dataProvider: DataProvider<T>) -> Transformer
}

// MARK: Extensions
extension AxisProtocol {
    // MARK: label information
    internal func labelTextColor(forEntry entry: CGFloat) -> UIColor {
        return colorFormatter?.colorForValue(entry) ?? labelConfig.textColor
    }
    
    internal func formattedLabel(forEntry entry: CGFloat) -> String {
        return AxisLabelCalculator.formattedLabel(forEntry: entry, using: valueFormatter)
    }

    // MARK: tranformed points
    internal func pixelPointForEntry(at index: Int, using transformer: Transformer) -> CGPoint {
        return preTransformedPoint(
            forEntry: entries[index]
        ).applying(transformer.valueToPixelMatrix)
    }

    internal func entryPixelPoints(using transformer: Transformer) -> NonEmptyArray<CGPoint> {
        return transformer.pointValuesToPixel(entries.map { preTransformedPoint(forEntry: $0) })
    }
}
