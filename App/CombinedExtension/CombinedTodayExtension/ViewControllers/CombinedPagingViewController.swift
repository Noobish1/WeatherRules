import Foundation
import NotificationCenter
import WhatToWearCore
import WhatToWearCoreUI
import WhatToWearExtensionCore
import WhatToWearModels

internal final class CombinedPagingViewController: CodeBackedViewController, ContainerViewControllerProtocol, ForecastBasedViewControllerProtocol, MainAppLauncherProtocol {
    // MARK: InnerViewController
    internal enum InnerViewController {
        case middle(CombinedContainerViewController)
        case end(EndViewController)
        
        internal var viewController: UIViewController {
            switch self {
                case .middle(let vc): return vc
                case .end(let vc): return vc
            }
        }
    }
    
    // MARK: properties
    private let headerView = UIView()
    private lazy var backButton = self.navigationButton(
        withTitle: NSLocalizedString("<", comment: ""),
        action: #selector(backButtonTapped)
    )
    private lazy var forwardButton = self.navigationButton(
        withTitle: NSLocalizedString(">", comment: ""),
        action: #selector(forwardButtonTapped)
    )
    private lazy var dateLabel = self.titleLabel(fontSize: 27).then {
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(doubleTapGestureRecognizer)
    }
    private lazy var doubleTapGestureRecognizer = UITapGestureRecognizer().then {
        $0.addTarget(self, action: #selector(labelDoubleTapRecognized))
        $0.numberOfTapsRequired = 2
    }
    private lazy var locationLabel = self.titleLabel(fontSize: 14)
    private lazy var displayModeButton = BorderedInsetButton(onTap: { [weak self] in
        self?.switchDisplayMode()
    }).then {
        $0.label.font = .systemFont(ofSize: 13)
        $0.label.text = displayMode.toggled().stringRepresentation
    }
    private lazy var openAppButton = BorderedInsetButton(onTap: { [weak self] in
        self?.openMainApp(fromExtension: .combined)
    }).then {
        $0.label.font = .systemFont(ofSize: 13)
        $0.label.text = NSLocalizedString("Open App", comment: "")
    }
    private lazy var legendOrRulesButton = BorderedInsetButton(onTap: { [weak self] in
        guard let strongSelf = self else { return }
        
        switch strongSelf.displayMode {
            case .rules:
                strongSelf.openRulesScreen(fromExtension: .combined)
            case .forecast:
                strongSelf.openLegendScreen(fromExtension: .combined)
        }
    }).then {
        $0.label.font = .systemFont(ofSize: 13)
        $0.label.text = NSLocalizedString("Legend", comment: "")
    }
    private let buttonsContainerView = UIView()
    internal let containerView = UIView()
    
    // swiftlint:disable implicitly_unwrapped_optional
    private var innerViewController: InnerViewController!
    // swiftlint:enable implicitly_unwrapped_optional
    private let calendar: Calendar
    private let timeZone: TimeZone
    private let initialParams: ForecastLoadingParams
    
    private var selectedDate: Date {
        didSet {
            self.dateLabel.text = Self.dateLabelText(for: selectedDate, timeZone: timeZone)
        }
    }
    private var displayMode: CombinedExtensionDisplayMode {
        didSet {
            self.displayModeButton.label.text = displayMode.toggled().stringRepresentation
            self.legendOrRulesButton.label.text = Self.legendOrRulesButtonText(displayMode: displayMode)
        }
    }
    
    // MARK: init
    internal init(params: ForecastLoadingParams) {
        let timeZone = params.timedForecast.forecast.timeZone
        let displayMode = CombinedExtensionSettingsController.shared.retrieve().displayMode
        
        self.selectedDate = params.date
        self.calendar = Calendars.shared.calendar(for: timeZone)
        self.timeZone = timeZone
        self.displayMode = displayMode
        self.initialParams = params
        
        super.init()
        
        self.dateLabel.text = Self.dateLabelText(for: params.date, timeZone: timeZone)
        self.locationLabel.text = params.location.address
        self.legendOrRulesButton.label.text = Self.legendOrRulesButtonText(displayMode: displayMode)
        self.innerViewController = .middle(self.makeMiddleViewController(for: .now, onLoadComplete: params.onLoadComplete))
    }
    
    deinit {
        dateLabel.removeGestureRecognizer(doubleTapGestureRecognizer)
    }
    
    // MARK: init helpers
    private static func legendOrRulesButtonText(displayMode: CombinedExtensionDisplayMode) -> String {
        switch displayMode {
            case .rules: return NSLocalizedString("Rules", comment: "")
            case .forecast: return NSLocalizedString("Legend", comment: "")
        }
    }
    
    private static func dateLabelText(for date: Date, timeZone: TimeZone) -> String {
        if Calendars.shared.calendar(for: timeZone).isDateInToday(date) {
            return NSLocalizedString("Today", comment: "")
        } else {
            return DateFormatters.shared.dayFormatter(for: timeZone).string(from: date)
        }
    }
    
    // MARK: setup
    private func setupViews() {
        self.view.add(subview: backButton, withConstraints: { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
        })
        
        self.view.add(subview: forwardButton, withConstraints: { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
        })
        
        self.view.insertSubview(dateLabel, at: 0, withConstraints: { make in
            make.top.equalToSuperview().offset(ExtensionConstants.forecastTopAndBottomPadding)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(CombinedExtensionConstants.combinedDateLabelHeight)
        })
        
        self.view.insertSubview(locationLabel, at: 0, withConstraints: { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(CombinedExtensionConstants.combinedInterLabelPadding)
            make.leading.greaterThanOrEqualToSuperview().offset(10)
            make.trailing.lessThanOrEqualToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(ExtensionConstants.forecastLocationLabelHeight)
        })
        
        self.view.insertSubview(containerView, at: 0, withConstraints: { make in
            make.top.equalTo(locationLabel.snp.bottom)
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        })
        
        setupInitialViewController(innerViewController.viewController, containerView: containerView)
        
        self.view.add(
            subview: buttonsContainerView,
            withConstraints: { make in
                make.top.equalTo(containerView.snp.bottom).offset(CombinedExtensionConstants.combinedChartButtonsInterPadding)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.height.equalTo(CombinedExtensionConstants.combinedButtonsContainerHeight)
                make.bottom.equalToSuperview().inset(ExtensionConstants.forecastTopAndBottomPadding).priority(.high)
            },
            subviews: { container in
                container.add(subview: legendOrRulesButton, withConstraints: { make in
                    make.leading.equalToSuperview().offset(10)
                    make.centerY.equalToSuperview()
                    make.top.equalToSuperview()
                    make.bottom.equalToSuperview()
                })
                
                container.add(subview: openAppButton, withConstraints: { make in
                    make.center.equalToSuperview()
                    make.top.equalToSuperview()
                    make.bottom.equalToSuperview()
                })
                
                container.add(subview: displayModeButton, withConstraints: { make in
                    make.trailing.equalToSuperview().inset(10)
                    make.centerY.equalToSuperview()
                    make.top.equalToSuperview()
                    make.bottom.equalToSuperview()
                    make.width.equalTo(legendOrRulesButton)
                    make.width.equalTo(openAppButton)
                })
            }
        )
    }
    
    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    // MARK: interface actions
    private func switchDisplayMode() {
        let nextDisplayMode = displayMode.toggled()
        let controller = CombinedExtensionSettingsController.shared
        
        let oldSettings = controller.retrieve()
        let newSettings = oldSettings.with(\.displayMode, value: nextDisplayMode)
        
        controller.save(newSettings)
        
        self.displayMode = nextDisplayMode
    }
    
    @objc
    private func labelDoubleTapRecognized() {
        moveToToday()
    }
    
    @objc
    private func backButtonTapped() {
        moveToSide(.past)
    }
    
    @objc
    private func forwardButtonTapped() {
        moveToSide(.future)
    }
    
    // MARK: moving pages
    private func moveToToday() {
        transitionToMiddleViewController(for: .now)
    }
    
    private func moveToSide(_ side: EndViewController.Side) {
        let date: Date
        let limitDate: Date
        let compareClosure: (Date, Date) -> Bool
        
        switch side {
            case .future:
                date = dateByAdding(days: 1, to: selectedDate)
                limitDate = dateByAdding(days: ForecastWindow.Distance.inTheFuture.rawValue, to: .now)
                compareClosure = { $0 < $1 }
            case .past:
                date = dateByAdding(days: -1, to: selectedDate)
                limitDate = dateByAdding(days: ForecastWindow.Distance.inThePast.rawValue, to: .now)
                compareClosure = { $0 > $1 }
        }
        
        if calendar.isDate(date, inSameDayAs: limitDate) {
            let endVC: InnerViewController = .end(makeEndViewController(side: side))
            
            transition(toViewController: endVC, for: date)
        } else if compareClosure(date, limitDate) {
            transitionToMiddleViewController(for: date)
        }
    }
    
    // MARK: transitioning
    private func transitionToMiddleViewController(for date: Date) {
        let vc: InnerViewController = .middle(makeMiddleViewController(for: date, onLoadComplete: nil))
        
        transition(toViewController: vc, for: date)
    }
    
    private func transition(toViewController: InnerViewController, for date: Date) {
        transitionFromViewController(innerViewController.viewController, toViewController: toViewController.viewController, containerView: containerView)
        
        self.innerViewController = toViewController
        self.selectedDate = date
    }
    
    // MARK: handling unchanged forecasts
    internal func handleUnchangedForecast(_ timedForecast: TimedForecast, onComplete: ((NCUpdateResult) -> Void)?) {
        let ourVC: InnerViewController = innerViewController
        
        switch ourVC {
            case .end: break
            case .middle(let vc): vc.handleUnchangedForecast(timedForecast, onComplete: onComplete)
        }
    }
    
    // MARK: making viewcontrollers
    private func makeEndViewController(side: EndViewController.Side) -> EndViewController {
        return EndViewController(side: side, context: .combinedTodayExtension, onButtonTap: { [weak self] in
            self?.moveToToday()
        })
    }
    
    private func makeMiddleViewController(
        for date: Date,
        onLoadComplete: ((NCUpdateResult) -> Void)?
    ) -> CombinedContainerViewController {
        return CombinedContainerViewController(params: initialParams.with(\LocationContainerParams.date, value: date))
    }
    
    // MARK: making navigation buttons
    private func navigationButton(withTitle title: String, action: Selector) -> UIButton {
        return UIButton().then {
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
            $0.setTitleColor(.white, for: .normal)
            $0.setTitleColor(UIColor.white.darker(by: 40.percent), for: .highlighted)
            $0.setTitle(title, for: .normal)
            $0.isExclusiveTouch = true
            $0.addTarget(self, action: action, for: .touchUpInside)
        }
    }
    
    // MARK: making title labels
    private func titleLabel(fontSize: CGFloat) -> UILabel {
        return UILabel().then {
            $0.font = .systemFont(ofSize: fontSize)
            $0.textColor = .white
            $0.textAlignment = .center
            $0.isUserInteractionEnabled = false
            $0.setContentCompressionResistancePriority(.required, for: .vertical)
            $0.setContentHuggingPriority(.required, for: .vertical)
        }
    }
    
    // MARK: creating dates
    private func dateByAdding(days: Int, to date: Date) -> Date {
        var components = DateComponents()
        components.day = days
        
        guard let newDate = calendar.date(byAdding: components, to: date) else {
            fatalError("Could not create date by adding components \(components) to date \(date)")
        }
        
        return newDate
    }
}

extension CombinedPagingViewController: ExtensionViewControllerProtocol {
    // MARK: ExtensionViewControllerProtocol
    internal func performUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        let ourVC: InnerViewController = innerViewController
        
        switch ourVC {
            case .middle(let vc): vc.performUpdate(completionHandler: completionHandler)
            case .end: break
        }
    }
    
    internal func preferredContentSize(for activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) -> CGSize {
        let ourVC: InnerViewController = innerViewController
        
        switch ourVC {
            case .middle(let vc): return vc.preferredContentSize(for: activeDisplayMode, withMaximumSize: maxSize)
            case .end: return maxSize
        }
    }
}
