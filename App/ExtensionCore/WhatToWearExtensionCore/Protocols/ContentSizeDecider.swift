import Foundation
import NotificationCenter

public protocol ContentSizeDecider {
    func preferredContentSize(
        for activeDisplayMode: NCWidgetDisplayMode,
        withMaximumSize maxSize: CGSize
    ) -> CGSize
}
