import RxCocoa
import RxRelay
import RxSwift
import UIKit
import WhatToWearCoreComponents
import WhatToWearModels

public class AppBackgroundView: CodeBackedView {
    // MARK: properties
    private var disposeBag = DisposeBag()
    public override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    private var ourLayer: CAGradientLayer {
        guard let ourLayer = layer as? CAGradientLayer else {
            fatalError("\(self).layer is not a CAGradientLayer and should be")
        }

        return ourLayer
    }
    private var option: AppBackgroundOptions = .original
    private let observeChanges: Bool

    // MARK: init
    public init(
        option: AppBackgroundOptions = GlobalSettingsController.shared.retrieve().appBackgroundOptions,
        observeChanges: Bool = true
    ) {
        self.observeChanges = observeChanges

        super.init(frame: .zero)

        configureLayer(with: option)
    }

    // MARK: UIView
    public override func didMoveToSuperview() {
        guard observeChanges else {
            return
        }

        disposeBag = DisposeBag()

        if superview != nil {
            setupObservers()
        }
    }

    // MARK: observers
    private func setupObservers() {
        GlobalSettingsController.shared.relay
            .asDriver()
            .distinctUntilChanged()
            .skip(1)
            .drive(onNext: { [ weak self] settings in
                self?.configureLayer(with: settings.appBackgroundOptions)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: configuration
    private func configureLayer(with newOption: AppBackgroundOptions) {
        resetLayer(for: option)

        switch newOption.background {
            case .gradient(hexColors: let hexColors, locations: let locations):
                self.ourLayer.colors = hexColors.map { UIColor(hex: $0).cgColor }
                self.ourLayer.locations = locations.map(NSNumber.init)
            case .color(hex: let hexColor):
                self.ourLayer.backgroundColor = UIColor(hex: hexColor).cgColor
        }
    }
    
    // MARK: resetting
    private func resetLayer(for option: AppBackgroundOptions) {
        switch option.background {
            case .gradient:
                self.ourLayer.colors = nil
                self.ourLayer.locations = nil
            case .color:
                self.ourLayer.backgroundColor = nil
        }
    }
}
