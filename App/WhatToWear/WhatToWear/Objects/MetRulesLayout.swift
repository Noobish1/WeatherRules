import CoreGraphics

internal enum MetRulesLayout {
    case portrait
    case landscape

    internal init(viewSize: CGSize) {
        if viewSize.width > viewSize.height {
            self = .landscape
        } else {
            self = .portrait
        }
    }
}
