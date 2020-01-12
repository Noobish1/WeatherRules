import CoreGraphics
import Foundation
import WhatToWearCommonModels
import WhatToWearModels

public enum FillType: Equatable {
    case color(CGColor)
    case linearGradient(CGGradient, angle: Degrees<Double>)
    case image(CGImage, tiled: Bool)
    case layer(CGLayer)

    // MARK: Drawing code
    private func fillColorPath(color: CGColor, context: CGContext) {
        context.saveGState()
        context.setFillColor(color)
        context.fillPath()
        context.restoreGState()
    }

    private func fillImagePath(image: CGImage, tiled: Bool, context: CGContext, rect: CGRect) {
        context.saveGState()
        context.clip()
        context.draw(image, in: rect, byTiling: tiled)
        context.restoreGState()
    }

    private func fillLayerPath(layer: CGLayer, context: CGContext, rect: CGRect) {
        context.saveGState()
        context.clip()
        context.draw(layer, in: rect)
        context.restoreGState()
    }

    private func fillLinearGradient(
        gradient: CGGradient,
        angle: Degrees<Double>,
        context: CGContext,
        rect: CGRect
    ) {
        context.saveGState()

        let radians = (360.0 - angle).toRadians()
        let centerPoint = CGPoint(x: rect.midX, y: rect.midY)
        let xAngleDelta = cos(radians.rawValue) * Double(rect.width) / 2.0
        let yAngleDelta = sin(radians.rawValue) * Double(rect.height) / 2.0
        let startPoint = CGPoint(
            x: Double(centerPoint.x) - xAngleDelta,
            y: Double(centerPoint.y) - yAngleDelta
        )
        let endPoint = CGPoint(
            x: Double(centerPoint.x) + xAngleDelta,
            y: Double(centerPoint.y) + yAngleDelta
        )

        context.clip()
        context.drawLinearGradient(
            gradient,
            start: startPoint,
            end: endPoint,
            options: [.drawsAfterEndLocation, .drawsBeforeStartLocation]
        )
        context.restoreGState()
    }

    internal func fillPath(context: CGContext, rect: CGRect) {
        switch self {
            case .color(let color):
                fillColorPath(color: color, context: context)
            case .image(let image, tiled: let tiled):
                fillImagePath(image: image, tiled: tiled, context: context, rect: rect)
            case .layer(let layer):
                fillLayerPath(layer: layer, context: context, rect: rect)
            case .linearGradient(let gradient, let angle):
                fillLinearGradient(
                    gradient: gradient, angle: angle, context: context, rect: rect
                )
        }
    }
}
