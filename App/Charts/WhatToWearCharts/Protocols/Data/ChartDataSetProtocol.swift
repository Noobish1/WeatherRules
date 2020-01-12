import CoreGraphics
import Foundation
import WhatToWearCommonCore
import WhatToWearCore

public protocol ChartDataSetProtocol {
    var values: NonEmptyArray<CGPoint> { get }
    var axisDependency: YAxis.Dependency { get }
    var valueConfig: ValueConfig? { get }
    var isVisible: Bool { get }

    func drawingYPosition(for yValue: CGFloat, valueConfig: ValueConfig) -> CGFloat
}
