import ErrorRecorder
import NotificationCenter
import UIKit
import WhatToWearCore
import WhatToWearCoreUI
import WhatToWearExtensionCore
import WhatToWearModels

internal final class ForecastViewController: CodeBackedViewController, ForecastDisplayerViewControllerProtocol {
    // MARK: properties
    private let chart: WeatherChartView
    
    internal let initialParams: ForecastLoadingParams
    
    // MARK: init
    internal init(params: ForecastLoadingParams) {
        self.chart = WeatherChartView(params: .init(params: params), context: .todayExtension)
        self.initialParams = params
        
        super.init()
    }
    
    // MARK: setup
    private func setupViews() {
        self.view.add(subview: chart, withConstraints: { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(chart.snp.width).multipliedBy(CombinedExtensionConstants.combinedChartAspectRatio)
            make.bottom.equalToSuperview()
        })
    }
    
    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        onAppear()
    }
}
