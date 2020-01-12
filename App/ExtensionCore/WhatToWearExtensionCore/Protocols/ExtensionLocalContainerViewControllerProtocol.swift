import Foundation
import NotificationCenter
import WhatToWearCoreUI

// MARK: ExtensionLocalContainerViewControllerProtocol
public protocol ExtensionLocalContainerViewControllerProtocol: ExtensionViewControllerProtocol, StatefulContainerViewController where State: ExtensionLocalContainerStateProtocol {
    func makeState(with completionHandler: (@escaping (NCUpdateResult) -> Void)) -> State
}

// MARK: General extensions
extension ExtensionLocalContainerViewControllerProtocol {
    public func performUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        let newState = makeState(with: completionHandler)

        guard newState != state else {
            state
                .asExtensionViewController()
                .performUpdate(completionHandler: completionHandler)

            return
        }

        transition(to: newState)
    }

    public func preferredContentSize(
        for activeDisplayMode: NCWidgetDisplayMode,
        withMaximumSize maxSize: CGSize
    ) -> CGSize {
        return state.asExtensionViewController().preferredContentSize(
            for: activeDisplayMode,
            withMaximumSize: maxSize
        )
    }
}
