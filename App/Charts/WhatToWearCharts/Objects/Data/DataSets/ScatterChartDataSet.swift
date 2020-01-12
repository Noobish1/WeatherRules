import CoreGraphics
import Foundation
import WhatToWearCommonCore
import WhatToWearCore

public struct ScatterChartDataSet: ChartDataSetProtocol {
    // MARK: types
    public struct ScatterConfig {
        public let shapeSize: CGFloat
        public let shapeRenderer: ShapeRendererProtocol
        public let colors: NonEmptyArray<UIColor>

        public init(
            shapeSize: CGFloat,
            shapeRenderer: ShapeRendererProtocol,
            colors: NonEmptyArray<UIColor>
        ) {
            self.shapeSize = shapeSize
            self.shapeRenderer = shapeRenderer
            self.colors = colors
        }
    }

    // MARK: properties
    public let axisDependency: YAxis.Dependency
    public let values: NonEmptyArray<CGPoint>
    public let valueConfig: ValueConfig?
    public let isVisible: Bool
    public let scatterConfig: ScatterConfig?

    public init(
        values: NonEmptyArray<CGPoint>,
        axisDependency: YAxis.Dependency,
        valueConfig: ValueConfig? = nil,
        isVisible: Bool = true,
        scatterConfig: ScatterConfig?
    ) {
        self.values = values
        self.axisDependency = axisDependency
        self.valueConfig = valueConfig
        self.isVisible = isVisible

        self.scatterConfig = scatterConfig
    }

    // MARK: drawing postions
    public func drawingYPosition(for yValue: CGFloat, valueConfig: ValueConfig) -> CGFloat {
        return yValue - (scatterConfig?.shapeSize ?? 10) - valueConfig.font.lineHeight
    }
}
