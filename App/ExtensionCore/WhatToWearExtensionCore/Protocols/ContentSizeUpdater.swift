import Foundation
import NotificationCenter

// MARK: ContentSizeUpdater
public protocol ContentSizeUpdater: UIViewController {
    var setPreferredContentSize: (CGSize) -> Void { get }
}

// MARK: Extensions where Self: ContentSizeDecider
extension ContentSizeUpdater where Self: ContentSizeDecider {
    // MARK: updating preferred contentsize
    public func updatePreferredContentSize(displayMode: NCWidgetDisplayMode, maxSize: CGSize) {
        let newContentSize = preferredContentSize(
            for: displayMode,
            withMaximumSize: maxSize
        )

        setPreferredContentSize(newContentSize)
    }

    public func updatePreferredContentSize() {
        guard let extensionContext = self.extensionContext else {
            return
        }

        let displayMode = extensionContext.widgetActiveDisplayMode
        let maxSize = extensionContext.widgetMaximumSize(for: displayMode)

        updatePreferredContentSize(displayMode: displayMode, maxSize: maxSize)
    }
}
