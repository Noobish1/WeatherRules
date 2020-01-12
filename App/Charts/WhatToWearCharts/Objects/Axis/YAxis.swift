import CoreGraphics
import Foundation
import UIKit
import WhatToWearCommonCore
import WhatToWearCore

public struct YAxis: AxisProtocol {
    // MARK: types
    public enum LabelPosition {
        case outsideChart
        case insideChart
    }

    public enum Dependency {
        case left
        case right
    }

    // MARK: computed properties
    internal var textAlignment: NSTextAlignment {
        switch (dependency, labelPosition) {
            case (.left, .outsideChart): return .right
            case (.left, .insideChart): return .left
            case (.right, .outsideChart): return .left
            case (.right, .insideChart): return .right
        }
    }

    // MARK: properties
    public let valueFormatter: AxisValueFormatterProtocol
    public let colorFormatter: AxisColorFormatterProtocol?
    public let labelConfig: LabelConfig
    public let labelOffset: CGFloat
    public let gridConfig: GridConfig
    public let offset: UIOffset
    public let labelPosition: LabelPosition
    public let dependency: Dependency

    public let range: ClosedRange<CGFloat>
    internal let entries: NonEmptyArray<CGFloat>

    // MARK: init
    public init(
        entries: NonEmptyArray<CGFloat>,
        labelConfig: LabelConfig,
        labelOffset: CGFloat,
        gridConfig: GridConfig,
        offset: UIOffset = UIOffset(horizontal: 5, vertical: 0),
        valueFormatter: AxisValueFormatterProtocol,
        colorFormatter: AxisColorFormatterProtocol? = nil,
        labelPosition: LabelPosition,
        dependency: Dependency
    ) {
        self.entries = entries
        self.range = entries.min()...entries.max()
        self.labelConfig = labelConfig
        self.labelOffset = labelOffset
        self.gridConfig = gridConfig
        self.offset = offset
        self.valueFormatter = valueFormatter
        self.colorFormatter = colorFormatter
        self.labelPosition = labelPosition
        self.dependency = dependency
    }

    // MARK: drawing positions
    internal func drawingXPosition(
        for viewPortHandler: ViewPortHandler,
        xOffset: CGFloat
    ) -> CGFloat {
        switch (dependency, labelPosition) {
            case (.left, .outsideChart):
                return viewPortHandler.offset.left - xOffset
            case (.left, .insideChart):
                return viewPortHandler.offset.left + xOffset
            case (.right, .outsideChart):
                return viewPortHandler.contentRect.maxX + xOffset
            case (.right, .insideChart):
                return viewPortHandler.contentRect.maxX - xOffset
        }
    }

    internal func preTransformedPoint(forEntry entry: CGFloat) -> CGPoint {
        return CGPoint(x: 0, y: entry)
    }

    internal func gridLines<T>(dataProvider: DataProvider<T>) -> NonEmptyArray<GridLine> {
        let trans = transformer(from: dataProvider)
        let viewPortHandler = dataProvider.viewPortHandler

        return entryPixelPoints(using: trans).map {
            GridLine(
                start: CGPoint(x: viewPortHandler.contentRect.minX, y: $0.y),
                end: CGPoint(x: viewPortHandler.contentRect.maxX, y: $0.y)
            )
        }
    }

    internal func pointToDrawAtForEntry<T>(at index: Int, dataProvider: DataProvider<T>) -> CGPoint {
        let trans = transformer(from: dataProvider)
        let viewPortHandler = dataProvider.viewPortHandler

        let xOffset = offset.horizontal
        let yOffset = labelConfig.font.lineHeight / 2.5 + offset.vertical
        let yPoint = pixelPointForEntry(at: index, using: trans).y

        return CGPoint(
            x: drawingXPosition(for: viewPortHandler, xOffset: xOffset),
            y: yPoint + (yOffset - labelConfig.font.lineHeight)
        )
    }

    internal func transformer<T>(from dataProvider: DataProvider<T>) -> Transformer {
        return dataProvider.transformer(forAxis: dependency)
    }
}
