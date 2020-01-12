import UIKit
import WhatToWearCoreUI
import WhatToWearModels

internal final class LegendComponentContentView: CodeBackedView {
    // MARK: properties
    private let navBarSeparatorView = SeparatorView()
    private let containerView = UIView()
    private let scrollView = UIScrollView()
    private let chartView: WeatherChartView
    private let descriptionLabel = UILabel().then {
        $0.textColor = .white
        $0.numberOfLines = 0
    }
    
    // MARK: init
    internal init(
        chartParams: WeatherChartView.Params,
        component: WeatherChartComponent,
        viewModel: LegendComponentViewModel,
        layout: LegendComponentViewController.Layout
    ) {
        self.chartView = WeatherChartView(
            params: chartParams.with(\.componentsToShow, value: Set([component])),
            context: .legend
        )
        
        super.init(frame: .zero)
        
        self.descriptionLabel.text = viewModel.description
        
        setupViews(layout: layout)
    }
    
    // MARK: setup
    private func setupViews(layout: LegendComponentViewController.Layout) {
        add(topSeparatorView: navBarSeparatorView)

        add(subview: containerView, withConstraints: { make in
            make.top.equalTo(navBarSeparatorView.snp.bottom)
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
            make.bottom.equalToSuperviewOrSafeAreaLayoutGuide()
        })

        setupContainerView(for: layout)
    }
    
    private func setupContainerView(for layout: LegendComponentViewController.Layout) {
        descriptionLabel.font = layout.descriptionFont

        switch layout {
            case .pad, .phone(orientation: .portrait, size: _):
                containerView.add(fullscreenSubview: scrollView)

                scrollView.add(subview: chartView, withConstraints: { make in
                    make.top.equalToSuperview()
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                    make.width.equalToSuperview()
                    make.height.equalTo(chartView.snp.width)
                        .multipliedBy(layout.chartAspectRatio)
                })

                scrollView.add(subview: descriptionLabel, withConstraints: { make in
                    make.top.equalTo(chartView.snp.bottom).offset(10)
                    make.leading.equalToSuperview().offset(20)
                    make.trailing.equalToSuperview().inset(20)
                    make.bottom.equalToSuperview()
                })
            case .phone(orientation: .landscape, size: let phoneSize):
                containerView.add(subview: chartView, withConstraints: { make in
                    make.top.equalTo(navBarSeparatorView.snp.bottom)
                        .offset(phoneSize.landscapeChartTopOffset)
                    make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
                    make.height.equalTo(chartView.snp.width)
                        .multipliedBy(layout.chartAspectRatio)
                })

                containerView.add(subview: scrollView, withConstraints: { make in
                    make.top.equalToSuperview()
                    make.leading.equalTo(chartView.snp.trailing)
                    make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
                    make.width.equalTo(chartView)
                    make.bottom.equalToSuperviewOrSafeAreaLayoutGuide()
                })

                scrollView.add(subview: descriptionLabel, withConstraints: { make in
                    make.top.equalTo(navBarSeparatorView.snp.bottom).offset(50)
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperviewOrSafeAreaLayoutGuide().inset(20)
                    make.bottom.equalToSuperview()
                    make.width.lessThanOrEqualTo(chartView)
                })
        }
    }
    
    // MARK: updating
    internal func update(layout newLayout: LegendComponentViewController.Layout) {
        containerView.subviews.forEach {
            $0.removeFromSuperview()
        }

        scrollView.subviews.forEach {
            $0.removeFromSuperview()
        }

        setupContainerView(for: newLayout)
    }
}
