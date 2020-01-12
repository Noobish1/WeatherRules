import Foundation
import WhatToWearCoreUI
import WhatToWearModels

public enum LoadingContainerState<LoadedViewController: UIViewController>: ContainerViewControllerStateProtocol {
    case loading(LoadingViewController<LoadedViewController>)
    case loaded(LoadedViewController, forecast: TimedForecast, settings: GlobalSettings)
    case errored(ErrorViewController)

    // MARK: computed properties
    public var needsInitialLoad: Bool {
        switch self {
            case .loading, .errored: return true
            case .loaded: return false
        }
    }

    public var viewController: UIViewController {
        switch self {
            case .loading(let vc): return vc
            case .loaded(let vc, forecast: _, settings: _): return vc
            case .errored(let vc): return vc
        }
    }
}
