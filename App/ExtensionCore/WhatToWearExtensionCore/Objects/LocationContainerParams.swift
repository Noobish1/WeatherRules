import Foundation
import NotificationCenter
import WhatToWearCore

// MARK: LocationContainerParams
public struct LocationContainerParams: Withable {
    // MARK: properties
    public var date: Date
    public let extensionType: ExtensionType
    public let setPreferredContentSize: (CGSize) -> Void
    public var onLoadComplete: ((NCUpdateResult) -> Void)?
}
