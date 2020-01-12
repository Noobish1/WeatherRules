import Foundation
import WhatToWearCore

// MARK: Extensions
internal enum AxisPainter {
    // MARK: drawing
    internal static func renderAxes<T>(context: CGContext, dataProvider: DataProvider<T>) {
        AxisPainter.drawAxis(context: context, axis: dataProvider.xAxis, dataProvider: dataProvider)
        AxisPainter.drawAxis(context: context, axis: dataProvider.leftAxis, dataProvider: dataProvider)
        AxisPainter.drawAxis(context: context, axis: dataProvider.rightAxis, dataProvider: dataProvider)
    }

    private static func drawAxis<T, Axis: AxisProtocol>(
        context: CGContext, axis: Axis, dataProvider: DataProvider<T>
    ) {
        drawGridLines(context: context, axis: axis, dataProvider: dataProvider)
        drawAxisLabels(context: context, axis: axis, dataProvider: dataProvider)
    }

    private static func drawGridLines<T, Axis: AxisProtocol>(
        context: CGContext, axis: Axis, dataProvider: DataProvider<T>
    ) {
        guard axis.gridConfig.linesEnabled else {
            return
        }

        context.saveGState()
        context.setShouldAntialias(true)
        context.setStrokeColor(axis.gridConfig.color.cgColor)
        context.setLineWidth(axis.gridConfig.lineWidth)
        context.setLineCap(.butt)

        let lines = axis.gridLines(dataProvider: dataProvider)

        for line in lines {
            context.beginPath()
            context.move(to: line.start)
            context.addLine(to: line.end)
            context.strokePath()
        }

        context.restoreGState()
    }

    private static func drawAxisLabels<T, Axis: AxisProtocol>(
        context: CGContext, axis: Axis, dataProvider: DataProvider<T>
    ) {
        guard axis.labelConfig.enabled else {
            return
        }

        for (index, entry) in axis.entries.enumerated() {
            TextPainter.drawText(
                context: context,
                text: axis.formattedLabel(forEntry: entry),
                point: axis.pointToDrawAtForEntry(at: index, dataProvider: dataProvider),
                align: axis.textAlignment,
                attributes: [
                    .font: axis.labelConfig.font,
                    .foregroundColor: axis.labelTextColor(forEntry: entry)
                ]
            )
        }
    }
}
