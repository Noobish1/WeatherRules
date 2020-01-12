import Foundation

internal enum TextPainter {
    internal static func drawText(
        context: CGContext,
        text: String,
        point: CGPoint,
        align: NSTextAlignment,
        attributes: [NSAttributedString.Key: Any]
    ) {
        var point = point

        if align == .center {
            point.x -= text.size(withAttributes: attributes).width / 2.0
        } else if align == .right {
            point.x -= text.size(withAttributes: attributes).width
        }

        UIGraphicsPushContext(context)

        (text as NSString).draw(at: point, withAttributes: attributes)

        UIGraphicsPopContext()
    }
}
