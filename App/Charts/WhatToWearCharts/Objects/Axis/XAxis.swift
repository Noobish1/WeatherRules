import CoreGraphics
import Foundation
import WhatToWearCommonCore
import WhatToWearCore

public struct XAxis: AxisProtocol {
    // MARK: types
    public enum LabelPosition: Int {
        case top = 0
        case bottom = 1
    }

    // MARK: properties
    public let valueFormatter: AxisValueFormatterProtocol
    public let colorFormatter: AxisColorFormatterProtocol?
    public let labelConfig: LabelConfig
    public let gridConfig: GridConfig
    public let offset: UIOffset
    public let labelPosition: LabelPosition

    internal let range: ClosedRange<CGFloat>
    internal let entries: NonEmptyArray<CGFloat>

    // MARK: computed properties
    internal var textAlignment: NSTextAlignment {
        return .center
    }

    // MARK: init
    public init(
        entries: NonEmptyArray<CGFloat>,
        labelConfig: LabelConfig,
        gridConfig: GridConfig,
        offset: UIOffset = UIOffset(horizontal: 0, vertical: 0),
        valueFormatter: AxisValueFormatterProtocol,
        colorFormatter: AxisColorFormatterProtocol? = nil,
        labelPosition: LabelPosition
    ) {
        self.entries = entries
        self.range = entries.min()...entries.max()
        self.labelConfig = labelConfig
        self.gridConfig = gridConfig
        self.offset = offset
        self.valueFormatter = valueFormatter
        self.colorFormatter = colorFormatter
        self.labelPosition = labelPosition
    }

    // MARK: label offsets
    internal func labelOffsetBottom() -> CGFloat {
        guard labelConfig.enabled, labelPosition == .bottom else {
            return 0
        }

        return labelConfig.font.lineHeight + offset.vertical
    }

    internal func labelOffsetTop() -> CGFloat {
        guard labelConfig.enabled, labelPosition == .top else {
            return 0
        }

        return labelConfig.font.lineHeight + offset.vertical
    }

    internal func drawingYPosition(for viewPortHandler: ViewPortHandler) -> CGFloat {
        let yOffset = offset.vertical

        switch labelPosition {
            case .top: return viewPortHandler.contentRect.minY - yOffset
            case .bottom: return viewPortHandler.contentRect.maxY + yOffset
        }
    }

    internal func preTransformedPoint(forEntry entry: CGFloat) -> CGPoint {
        return CGPoint(x: entry, y: 0)
    }

    internal func gridLines<T>(dataProvider: DataProvider<T>) -> NonEmptyArray<GridLine> {
        let trans = transformer(from: dataProvider)
        let viewPortHandler = dataProvider.viewPortHandler

        return entryPixelPoints(using: trans).map {
            GridLine(
                start: CGPoint(x: $0.x, y: viewPortHandler.contentRect.minY),
                end: CGPoint(x: $0.x, y: viewPortHandler.contentRect.maxY)
            )
        }
    }

    internal func pointToDrawAtForEntry<T>(at index: Int, dataProvider: DataProvider<T>) -> CGPoint {
        let trans = transformer(from: dataProvider)
        let viewPortHandler = dataProvider.viewPortHandler

        return CGPoint(
            x: pixelPointForEntry(at: index, using: trans).x,
            y: drawingYPosition(for: viewPortHandler)
        )
    }

    internal func transformer<T>(from dataProvider: DataProvider<T>) -> Transformer {
        return dataProvider.transformer(forAxis: .left)
    }
}
