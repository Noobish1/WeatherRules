import ErrorRecorder
import NotificationCenter
import RxCocoa
import RxSwift
import UIKit
import WhatToWearCore
import WhatToWearCoreComponents
import WhatToWearCoreUI
import WhatToWearExtensionCore
import WhatToWearModels
import WhatToWearNetworking

internal final class CombinedContainerViewController: CodeBackedViewController, ExtensionLocalContainerViewControllerProtocol, ForecastBasedViewControllerProtocol {
    // MARK: State
    internal enum State: ContainerViewControllerStateProtocol, ExtensionLocalContainerStateProtocol {
        case forecast(ForecastLoadingViewController<ForecastViewController>)
        case rules(RulesContainerViewController)
        
        // MARK: computed properties
        internal var viewController: UIViewController {
            switch self {
                case .forecast(let vc): return vc
                case .rules(let vc): return vc
            }
        }

        // MARK: init
        internal init(settings: CombinedExtensionSettings, params: ForecastLoadingParams) {
            let newParams = params.loadingContainerParams
            
            switch settings.displayMode {
                case .forecast:
                    self = .forecast(ForecastLoadingViewController(
                        params: newParams,
                        makeInnerViewController: ForecastViewController.init
                    ))
                case .rules:
                    self = .rules(RulesContainerViewController(params: newParams))
            }
        }
        
        // MARK: ExtensionLocalContainerStateProtocol
        internal func asExtensionViewController() -> ExtensionViewControllerProtocol {
            switch self {
                case .forecast(let vc): return vc
                case .rules(let vc): return vc
            }
        }
    }
    
    // MARK: properties
    internal var state: State
    internal var containerView: UIView {
        return view
    }
    
    private let disposeBag = DisposeBag()
    private let initialParams: ForecastLoadingParams
    
    // MARK: init
    internal init(params: ForecastLoadingParams) {
        self.initialParams = params
        self.state = State(
            settings: CombinedExtensionSettingsController.shared.retrieve(),
            params: params
        )
        
        super.init()
    }
    
    // MARK: setup
    private func setupViews() {
        setupInitialViewController(state.viewController, containerView: containerView)
        setupObservers()
    }
    
    private func setupObservers() {
        CombinedExtensionSettingsController.shared.relay
            .asDriver()
            .distinctUntilChanged()
            .skip(1)
            .drive(onNext: { [weak self] settings in
                guard let strongSelf = self else { return }
                
                let state = strongSelf.makeState(with: settings)
                
                strongSelf.transition(to: state)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    // MARK: making states
    internal func makeState(with completionHandler: @escaping ((NCUpdateResult) -> Void)) -> State {
        return State(
            settings: CombinedExtensionSettingsController.shared.retrieve(),
            params: initialParams.with(\LocationContainerParams.onLoadComplete, value: completionHandler)
        )
    }
    
    private func makeState(with settings: CombinedExtensionSettings) -> State {
        return State(settings: settings, params: initialParams)
    }
    
    // MARK: handling unchanged forecats
    internal func handleUnchangedForecast(_ timedForecast: TimedForecast, onComplete: ((NCUpdateResult) -> Void)?) {
        switch state {
            case .forecast: break
            case .rules(let vc): vc.handleUnchangedForecast(timedForecast, onComplete: onComplete)
        }
    }
}
