import ErrorRecorder
import Foundation
import NotificationCenter
import WhatToWearCoreUI

open class ExtensionRootViewController<InnerViewController: ExtensionViewControllerProtocol>: CodeBackedViewController, ContainerViewControllerProtocol, NCWidgetProviding {
    // MARK: properties
    private let extensionType: ExtensionType
    private let makeInnerViewController: (LoadingContainerParams) -> InnerViewController
    private lazy var innerViewController = LocationContainerViewController<InnerViewController>(
        params: .init(
            date: .now,
            extensionType: extensionType,
            setPreferredContentSize: { [weak self] newContentSize in
                self?.preferredContentSize = newContentSize
            },
            onLoadComplete: nil
        ),
        makeInnerViewController: makeInnerViewController
    )
    public var containerView: UIView {
        return view
    }

    // MARK: init
    // swiftlint:disable unavailable_function
    public override init() {
        // Need this for some reason otherwise it crashes
        fatalError("unimplemented init(), use init(extensionType:) instead")
    }
    // swiftlint:enable unavailable_function
    
    public init(
        extensionType: ExtensionType,
        makeInnerViewController: @escaping (LoadingContainerParams) -> InnerViewController
    ) {
        self.extensionType = extensionType
        self.makeInnerViewController = makeInnerViewController
        
        super.init()
    }
    
    // MARK: UIViewController
    open override func viewDidLoad() {
        super.viewDidLoad()

        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded

        setupInitialViewController(innerViewController, containerView: containerView)
    }
    
    // MARK: NCWidgetProviding
    public func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        innerViewController.performUpdate(completionHandler: completionHandler)
    }
    
    public func widgetActiveDisplayModeDidChange(
        _ activeDisplayMode: NCWidgetDisplayMode,
        withMaximumSize maxSize: CGSize
    ) {
        self.preferredContentSize = innerViewController.preferredContentSize(
            for: activeDisplayMode,
            withMaximumSize: maxSize
        )
        
        Analytics.record(event: .widgetDisplayModeChanged(activeDisplayMode))
    }
}
