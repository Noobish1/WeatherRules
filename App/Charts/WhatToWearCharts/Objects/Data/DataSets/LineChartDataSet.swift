import CoreGraphics
import Foundation
import WhatToWearCommonCore
import WhatToWearCore

public struct LineChartDataSet: ChartDataSetProtocol {
    // MARK: types
    public enum LineMode {
        case linear(colors: NonEmptyArray<UIColor>)
        case cubicBezier(color: UIColor)
    }

    public struct LineConfig {
        // MARK: properties
        public let mode: LineMode
        public let capType: CGLineCap
        public let width: CGFloat
        public let cubicIntensity: CGFloat
        
        // MARK: init
        public init(
            mode: LineMode, capType: CGLineCap, width: CGFloat, cubicIntensity: CGFloat = 0.2
        ) {
            self.mode = mode
            self.capType = capType
            self.width = width.clamped(to: 0...10)
            self.cubicIntensity = cubicIntensity.clamped(to: 0.05...1.0)
        }
    }

    public struct FillConfig {
        // MARK: properties
        public let type: FillType
        public let alpha: CGFloat
        public let formatter: FillFormatterProtocol

        // MARK: init
        public init(type: FillType, alpha: CGFloat, formatter: FillFormatterProtocol) {
            self.type = type
            self.alpha = alpha
            self.formatter = formatter
        }
    }

    // MARK: properties
    public let axisDependency: YAxis.Dependency
    public let values: NonEmptyArray<CGPoint>
    public let valueConfig: ValueConfig?
    public let isVisible: Bool
    public let lineConfig: LineConfig
    public let fillConfig: FillConfig?

    // MARK: init
    public init(
        values: NonEmptyArray<CGPoint>,
        axisDependency: YAxis.Dependency,
        valueConfig: ValueConfig? = nil,
        isVisible: Bool = true,
        lineConfig: LineConfig,
        fillConfig: FillConfig? = nil
    ) {
        self.values = values
        self.axisDependency = axisDependency
        self.valueConfig = valueConfig
        self.isVisible = isVisible

        self.lineConfig = lineConfig
        self.fillConfig = fillConfig
    }

    // MARK: drawing positions
    public func drawingYPosition(for yValue: CGFloat, valueConfig: ValueConfig) -> CGFloat {
        return yValue - valueConfig.font.lineHeight
    }
}
