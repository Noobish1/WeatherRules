import SnapKit
import UIKit
import WhatToWearCoreUI

internal final class LegendHeaderView: CodeBackedView {
    // MARK: properties
    private let chart: WeatherChartView
    private lazy var label = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.text = title
        $0.setContentHuggingPriority(.required, for: .vertical)
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    private lazy var bottomSeparatorView = SeparatorView().then {
        $0.isHidden = bottomSeparatorHidden
    }
    private let title: String
    private let bottomSeparatorHidden: Bool
    private let titleInsets: UIEdgeInsets
    
    // MARK: computed properties
    private var chartAspectRatio: CGFloat {
        switch InterfaceIdiom.current {
            case .phone: return Constants.chartAspectRatio
            case .pad: return 180 / 540
        }
    }
    
    // MARK: init
    internal init(
        chartParams: WeatherChartView.Params,
        title: String,
        bottomSeparatorHidden: Bool,
        titleInsets: UIEdgeInsets
    ) {
        self.chart = WeatherChartView(params: chartParams, context: .legend)
        self.title = title
        self.bottomSeparatorHidden = bottomSeparatorHidden
        self.titleInsets = titleInsets

        super.init(frame: UIScreen.main.bounds)

        setupViews()
    }

    // MARK: setup
    private func setupViews() {
        add(subview: chart, withConstraints: { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(chart.snp.width)
                .multipliedBy(chartAspectRatio)
                .priority(.almostRequired)
        })

        add(subview: label, withConstraints: { make in
            make.top.equalTo(chart.snp.bottom).offset(titleInsets.top)
            make.leading.equalToSuperview().offset(titleInsets.left)
            make.trailing.equalToSuperview().inset(titleInsets.right)
        })

        add(subview: bottomSeparatorView, withConstraints: { make in
            make.top.equalTo(label.snp.bottom).offset(titleInsets.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        })
    }
}
