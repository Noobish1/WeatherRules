import UIKit
import WhatToWearCoreUI
import WhatToWearModels

// MARK: MetRulesViewControllerProtocol
internal protocol MetRulesViewControllerProtocol: NavStackEmbedded {
    var portraitHeaderView: DayTableHeaderView { get }
    var landscapeLeftContainerView: UIView { get }
    var landscapeHeaderView: DayTableHeaderView { get }
    var landscapeHeaderContainerView: UIView { get }
    var landscapeHorizontalSeparatorView: SeparatorView { get }
    var whatToWearHeaderView: WhatToWearHeaderView { get }
    var chartParams: WeatherChartView.Params { get }
    var settings: GlobalSettings { get }
    var onLabelDoubleTap: () -> Void { get }
    var layout: MetRulesLayout { get set }

    func setupViews(for layout: MetRulesLayout)
    func rulesButtonTapped()
    func legendButtonTapped()
}

// MARK: Protocol extensions
extension MetRulesViewControllerProtocol {
    // MARK: init helpers
    internal func makeHeaderView(forLayout layout: DayTableHeaderView.Layout) -> DayTableHeaderView {
        return DayTableHeaderView(
            chartParams: chartParams,
            layout: layout,
            headerConfig: .rulesAndLegend(onRulesButtonTap: { [weak self] in
                self?.rulesButtonTapped()
            }, onLegendButtonTap: { [weak self] in
                self?.legendButtonTapped()
            }),
            onLabelDoubleTap: onLabelDoubleTap
        )
    }

    internal func makeWhatToWearHeaderView() -> WhatToWearHeaderView {
        return WhatToWearHeaderView(
            config: .rulesAndLegend(onRulesButtonTap: { [weak self] in
                self?.rulesButtonTapped()
            }, onLegendButtonTap: { [weak self] in
                self?.legendButtonTapped()
            })
        )
    }
    
    // MARK: layout
    internal func layoutLandscapeViews(leftContainerViewSubviews: (UIView) -> Void) {
        switch InterfaceIdiom.current {
            case .pad:
                layoutLandscapeViewsForIPad(leftContainerViewSubviews: leftContainerViewSubviews)
            case .phone:
                layoutLandscapeViewsForIPhone(leftContainerViewSubviews: leftContainerViewSubviews)
        }
    }
    
    private func layoutLandscapeViewsForIPhone(leftContainerViewSubviews: (UIView) -> Void) {
        view.add(subview: landscapeHeaderView, withConstraints: { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        })

        view.add(
            subview: landscapeLeftContainerView,
            withConstraints: { make in
                make.top.equalToSuperview()
                make.leading.equalTo(landscapeHeaderView.snp.trailing)
                make.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
                make.width.equalTo(landscapeHeaderView)
            },
            subviews: leftContainerViewSubviews
        )
    }
    
    private func layoutLandscapeViewsForIPad(leftContainerViewSubviews: (UIView) -> Void) {
        view.add(
            subview: landscapeHeaderContainerView,
            withConstraints: { make in
                make.top.equalToSuperview()
                make.leading.equalToSuperview()
                // We inset by 20 to move the header up 20 points to make it look more center
                make.bottom.equalToSuperview().inset(20)
                make.width.equalToSuperview().multipliedBy(0.7)
            },
            subviews: { container in
                container.add(subview: landscapeHeaderView, withConstraints: { make in
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                    make.centerY.equalToSuperview()
                })
            }
        )

        view.add(subview: landscapeHorizontalSeparatorView, withConstraints: { make in
            make.top.equalToSuperview()
            make.leading.equalTo(landscapeHeaderContainerView.snp.trailing)
            make.bottom.equalToSuperview()
            make.width.equalTo(1)
        })
        
        view.add(
            subview: landscapeLeftContainerView,
            withConstraints: { make in
                make.top.equalToSuperview()
                make.leading.equalTo(landscapeHorizontalSeparatorView.snp.trailing)
                make.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
            },
            subviews: leftContainerViewSubviews
        )
    }

    // MARK: interface actions
    internal func rulesButtonTapped() {
        let vc = RulesViewController()
        
        switch InterfaceIdiom.current {
            case .phone:
                navController.pushViewController(vc, animated: true)
            case .pad:
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .formSheet
            
                present(navVC, animated: true)
        }
    }

    internal func legendButtonTapped() {
        let vc = LegendViewController(settings: settings)

        switch InterfaceIdiom.current {
            case .phone:
                navController.pushViewController(vc, animated: true)
            case .pad:
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .formSheet
            
                present(navVC, animated: true)
        }
    }

    // MARK: transition
    internal func transition(toLayout newLayout: MetRulesLayout, force: Bool = false) {
        guard force || newLayout != self.layout else { return }

        view.subviews.forEach { $0.removeFromSuperview() }

        setupViews(for: newLayout)

        self.layout = newLayout
    }
}
