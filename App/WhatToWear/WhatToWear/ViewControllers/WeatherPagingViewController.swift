import ErrorRecorder
import SnapKit
import Then
import UIKit
import WhatToWearCommonCore
import WhatToWearCore
import WhatToWearCoreComponents
import WhatToWearCoreUI
import WhatToWearModels

internal final class WeatherPagingViewController: CodeBackedViewController, ContainerViewControllerProtocol, NavStackEmbedded, Accessible {
    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = WeatherPagingViewController

        case toolbarView = "toolbarView"
        case mainView = "mainView"
    }

    // MARK: InsertionEnd
    private enum InsertionPoint {
        case start
        case end

        fileprivate var daysToAddOrSubtract: Int {
            switch self {
                case .start: return -1
                case .end: return 1
            }
        }

        fileprivate var endVCSide: EndViewController.Side {
            switch self {
                case .start: return .past
                case .end: return .future
            }
        }
        
        fileprivate var maxDaysFromToday: Int {
            switch self {
                case .start: return ForecastWindow.Distance.inThePast.rawValue
                case .end: return ForecastWindow.Distance.inTheFuture.rawValue
            }
        }
        
        fileprivate func todayPageIndexAfterInitialWindowAddition<T>(in array: NonEmptyArray<T>) -> Int {
            switch self {
                case .start: return 1
                case .end: return array.endIndex - 2
            }
        }

        fileprivate func oldFirstPageIndexAfterInitialWindowAddition<T>(in array: NonEmptyArray<T>) -> Int {
            switch self {
                case .start: return array.endIndex - 2
                case .end: return 1
            }
        }

        fileprivate func removeIndex<T>(in array: NonEmptyArray<T>) -> Int {
            switch self {
                case .start: return array.endIndex - 1
                case .end: return 0
            }
        }

        fileprivate func insertionIndex<T>(in array: NonEmptyArray<T>) -> Int {
            switch self {
                case .start: return 0
                case .end: return array.endIndex
            }
        }

        fileprivate func removedVC<T>(in array: NonEmptyArray<T>) -> T {
            switch self {
                case .start: return array.last
                case .end: return array.first
            }
        }

        fileprivate func endVC<T>(in array: NonEmptyArray<T>) -> T {
            switch self {
                case .start: return array.first
                case .end: return array.last
            }
        }

        fileprivate func newEndVCIndexAfterScrolling<T>(in array: NonEmptyArray<T>) -> Int {
            switch self {
                case .start: return array.endIndex - 1
                case .end: return 0
            }
        }
    }

    // MARK: properties
    private let toolbarViewController: ToolbarViewController
    private let constraintMaker = PagingConstraintMaker()
    private let locationsController: StoredLocationsController
    private let calendar: Calendar
    private let today: Date
    private let timedForecast: TimedForecast
    private lazy var pagingController = WeatherPagingController().then {
        $0.pagingDelegate = self
    }
    private let dummyTodayViewController: UIViewController
    private lazy var viewControllers = self.createInitialViewControllers()

    internal let containerView = UIView()
    
    // MARK: status bar
    internal override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: init/deinit
    internal init(
        today: Date,
        locationsController: StoredLocationsController,
        timedForecast: TimedForecast
    ) {
        self.today = today
        self.locationsController = locationsController
        self.timedForecast = timedForecast
        self.calendar = Calendars.shared.calendar(for: timedForecast.forecast.timeZone)
        self.dummyTodayViewController = DayContainerViewController(
            params: .preloaded(
                date: today, location: locationsController.defaultLocation, forecast: timedForecast
            ),
            onLabelDoubleTap: {}
        )
        self.toolbarViewController = ToolbarViewController(
            timedForecast: timedForecast,
            locationsController: locationsController
        )

        super.init()

        let blankBackItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = blankBackItem
    }

    // MARK: setup
    private func setupDummyTodayViewController() {
        // We hide the scrollView and add a dummy TodayVC to the view hierachy
        // Because underneath the scrollView is laying out the 3 TodayVC's and
        // Scrolling to the middle one
        // If we don't do this, then when launching the app or switching locations
        // We see the preloadingVC ("Release finger to load") screen flicker before seeing
        // The correct TodayVC

        pagingController.scrollView.isHidden = true

        containerView.add(fullscreenSubview: dummyTodayViewController.view)

        self.addChild(dummyTodayViewController)

        dummyTodayViewController.didMove(toParent: self)

        dummyTodayViewController.view.isUserInteractionEnabled = false
    }

    private func teardownDummyTodayViewController() {
        self.pagingController.scrollView.isHidden = false

        self.dummyTodayViewController.willMove(toParent: nil)
        self.dummyTodayViewController.view.removeFromSuperview()
        self.dummyTodayViewController.removeFromParent()
    }

    private func setupViews() {
        view.add(subview: containerView, withConstraints: { make in
            make.top.equalToSuperviewOrSafeAreaLayoutGuide()
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
        })

        containerView.add(
            subview: pagingController.scrollView,
            withConstraints: { make in
                make.edges.equalToSuperview()
            }
        )

        setupDummyTodayViewController()

        view.add(subview: toolbarViewController.view, withConstraints: { make in
            make.top.equalTo(containerView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperviewOrSafeAreaLayoutGuide()
        })

        self.addChild(toolbarViewController)

        toolbarViewController.didMove(toParent: self)
    }

    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()

        view.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.mainView)

        pagingController.currentPage = 1
        
        setupViews()

        layoutInitialViewControllers(viewControllers)

        // We force a layout here so that we scroll to the page at index 1
        // If we don't do this it will just stay on the page at index 0
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        // We need to do this so that we can scroll *fully* to the correct page in landscape
        // If we don't do this, we end up scrolled a little too far to the right
        DispatchQueue.main.async {
            self.pagingController.scrollToCurrentPage(animated: false, force: true)
            
            self.teardownDummyTodayViewController()
        }
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        // Force a layout pass then scroll to the current page
        // because if we/ve changed orientations away from this screen then pages can get half-scrolled
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        pagingController.scrollToCurrentPage(animated: false, force: true)
    }

    // MARK: rotation
    internal override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { _ in
            self.pagingController.scrollToCurrentPage(animated: false, force: true)
        })
    }

    // MARK: creation
    private func dateByAdding(days: Int, to date: Date) -> Date {
        var components = DateComponents()
        components.day = days

        guard let newDate = calendar.date(byAdding: components, to: date) else {
            fatalError("Could not create date by adding components \(components) to date \(date)")
        }

        return newDate
    }

    private func createNextDayContainerViewController(at point: InsertionPoint, load: Bool) -> DayContainerViewController {
        let oldEndVC = point.endVC(in: viewControllers)

        return createDayContainerViewController(byAddingDays: point.daysToAddOrSubtract, to: oldEndVC.date, load: load)
    }

    private func createDayContainerViewController(byAddingDays days: Int, to date: Date, load: Bool = false) -> DayContainerViewController {
        let newDate = dateByAdding(days: days, to: date)

        return DayContainerViewController(
            params: .needsLoading(date: newDate, location: locationsController.defaultLocation, load: load),
            onLabelDoubleTap: { [weak self] in
                self?.scrollToToday()
            }
        )
    }

    private func createInitialViewControllers() -> NonEmptyArray<DayContainerViewController> {
        let yesterdayViewController = createDayContainerViewController(byAddingDays: -1, to: today)
        let todayViewController = DayContainerViewController(
            params: .preloaded(date: today, location: locationsController.defaultLocation, forecast: timedForecast),
            onLabelDoubleTap: { [weak self] in
                self?.scrollToToday()
            }
        )

        let tomorrowViewController = createDayContainerViewController(byAddingDays: 1, to: today)

        return NonEmptyArray(
            elements: yesterdayViewController, todayViewController, tomorrowViewController
        )
    }

    // MARK: layout
    private func layoutInitialViewControllers(
        _ viewControllers: NonEmptyArray<DayContainerViewController>
    ) {
        viewControllers.enumerated().forEach { index, vc in
            self.addViewInScrollView(vc.view, forPage: index)

            self.addChild(vc)

            vc.didMove(toParent: self)
        }
    }

    // MARK: Adding views to the pagingController's scrollView
    private func addViewInScrollView(_ view: UIView, forPage page: Int) {
        let constraints = makeViewControllerConstraints(forPage: page)
        
        pagingController.scrollView.add(subview: view, withConstraints: constraints)
    }
    
    private func insertViewInScrollView(_ view: UIView, forPage page: Int) {
        let constraints = makeViewControllerConstraints(forPage: page)
        
        pagingController.scrollView.insertSubview(view, at: 0, withConstraints: constraints)
    }

    // MARK: inserting/removing viewcontrollers
    private func insert(childViewController: UIViewController, forPage page: Int) {
        insertViewInScrollView(childViewController.view, forPage: page)
        
        addChild(childViewController)
        
        childViewController.didMove(toParent: self)
    }
    
    private func insertAndLayout(
        viewController: DayContainerViewController,
        to point: InsertionPoint,
        oldEndVC: DayContainerViewController,
        scroll: Bool
    ) {
        if scroll {
            // We alpha out the viewController's view so it doesn't flicker to the user
            viewController.view.alpha = 0
        }

        switch point {
            case .start:
                insert(childViewController: viewController, forPage: 0)

                // Remake constraints of the old zeroth viewcontroller
                oldEndVC.view.snp.remakeConstraints(makeViewControllerConstraints(forPage: 1))
            case .end:
                // Remake constraints of the old last viewcontroller
                let lastMinusOneConstraints = makeViewControllerConstraints(forPage: viewControllers.endIndex - 2)

                oldEndVC.view.snp.remakeConstraints(lastMinusOneConstraints)

                insert(childViewController: viewController, forPage: viewControllers.endIndex - 1)
        }

        if scroll {
            // Scroll to old last viewcontroller
            self.pagingController.scrollTo(
                page: point.oldFirstPageIndexAfterInitialWindowAddition(in: self.viewControllers),
                animated: false,
                force: true
            )

            viewController.view.alpha = 1
        }
    }

    private func insert(viewController: DayContainerViewController, AtPointAndRemoveAtOpposite point: InsertionPoint) {
        let oldEndVC = point.endVC(in: viewControllers)
        let removedVC = point.removedVC(in: viewControllers)

        switch point {
            case .start:
                viewControllers.removeLastElementAndAddElementToStart(viewController)
            case .end:
                viewControllers.removeFirstElementAndAddElementToEnd(viewController)
        }

        insertAndLayout(viewController: viewController, to: point, oldEndVC: oldEndVC, scroll: true)

        removeChildViewController(removedVC)
        
        remakeConstraintsForExistingViewController(forPage: point.removeIndex(in: viewControllers))
    }

    private func insertInitialViewControllersToPointAndScrollToToday(point: InsertionPoint, animated: Bool) {
        let vcsToRemove = viewControllers
        let todayWindowVCs: NonEmptyArray<DayContainerViewController>

        switch point {
            case .start: todayWindowVCs = createInitialViewControllers().reversed()
            case .end: todayWindowVCs = createInitialViewControllers()
        }

        todayWindowVCs.forEach { vc in
            let oldVCToReLayout = point.endVC(in: viewControllers)

            viewControllers.insert(vc, at: point.insertionIndex(in: viewControllers))

            insertAndLayout(viewController: vc, to: point, oldEndVC: oldVCToReLayout, scroll: false)

            let page = point.oldFirstPageIndexAfterInitialWindowAddition(in: viewControllers)

            self.pagingController.scrollTo(page: page, animated: false, force: true)
        }

        let todayPage = point.todayPageIndexAfterInitialWindowAddition(in: viewControllers)

        self.pagingController.scrollTo(page: todayPage, animated: animated, force: true, completion: {
            let newViewControllers = self.viewControllers.toArray().filter(todayWindowVCs.contains)

            guard let nonEmptyViewControllers = NonEmptyArray(array: newViewControllers) else {
                fatalError("We somehow managed to remove all viewControllers from the viewControllers array")
            }

            self.viewControllers = nonEmptyViewControllers

            vcsToRemove.forEach { vc in
                self.removeChildViewController(vc)
            }

            let newEndVCIndexAfterScrolling = point.newEndVCIndexAfterScrolling(in: self.viewControllers)
            
            self.remakeConstraintsForExistingViewController(forPage: newEndVCIndexAfterScrolling)

            if point == .end {
                self.pagingController.scrollTo(page: self.viewControllers.endIndex - 2, animated: false, force: true)
            }
        })
    }

    private func insertPage(at insertionPoint: InsertionPoint) {
        let nextDate = dateByAdding(days: insertionPoint.daysToAddOrSubtract, to: insertionPoint.endVC(in: viewControllers).date)
        let limitDate = dateByAdding(days: insertionPoint.maxDaysFromToday, to: today)
        
        let isNextDateWithinLimit: Bool
        
        switch insertionPoint {
            case .start: isNextDateWithinLimit = nextDate >= limitDate
            case .end: isNextDateWithinLimit = nextDate <= limitDate
        }
        
        if isNextDateWithinLimit {
            let vc = createNextDayContainerViewController(at: insertionPoint, load: true)
            
            insert(viewController: vc, AtPointAndRemoveAtOpposite: insertionPoint)
        } else if !insertionPoint.endVC(in: viewControllers).isEnd {
            let vc = DayContainerViewController(
                params: .end(
                    date: nextDate,
                    side: insertionPoint.endVCSide,
                    onButtonTap: { [weak self] in
                        self?.scrollToToday()
                    }
                ),
                onLabelDoubleTap: {}
            )
            
            insert(viewController: vc, AtPointAndRemoveAtOpposite: insertionPoint)
        }
    }
    
    // MARK: making constraints
    private func remakeConstraintsForExistingViewController(forPage page: Int) {
        let constraints = makeViewControllerConstraints(forPage: page)
        
        self.viewControllers[page].view.snp.remakeConstraints(constraints)
    }
    
    private func makeViewControllerConstraints(forPage page: Int) -> ((ConstraintMaker) -> Void) {
        return constraintMaker.constraints(
            at: page,
            in: viewControllers.map { $0.view }.toArray(),
            containerView: containerView
        )
    }
    
    // MARK: scrolling
    private func scrollToToday(animated: Bool = true) {
        let currentDate = viewControllers[Int(pagingController.currentPage)].date

        // Don't need to do anything if we're already on today's VC
        guard !calendar.isDate(currentDate, inSameDayAs: today) else { return }

        // If one of our existing viewcontrollers is today, scroll to it
        let todayComponents = calendar.dateComponents([.day, .month, .year], from: today)
        let vcComponents = viewControllers.map {
            calendar.dateComponents([.day, .month, .year], from: $0.date)
        }

        if let page = vcComponents.firstIndex(of: todayComponents) {
            pagingController.scrollTo(page: page, animated: animated)
        } else {
            if currentDate > today {
                insertInitialViewControllersToPointAndScrollToToday(point: .start, animated: animated)
            } else {
                insertInitialViewControllersToPointAndScrollToToday(point: .end, animated: animated)
            }
        }
    }
}

// MARK: WeatherPagingControllerDelegate
extension WeatherPagingViewController: WeatherPagingControllerDelegate {
    internal func pagingController(_ controller: WeatherPagingController, didMoveToPage page: Int) {
        viewControllers[safe: page]?.fetchIfNeeded()

        if page == 0 {
            // We don't set the currentPage in here before insertPage does it
            insertPage(at: .start)
        } else if page == (viewControllers.endIndex - 1) {
            // We don't set the currentPage in here before insertPage does it
            insertPage(at: .end)
        } else {
            viewControllers[safe: page - 1]?.fetchIfNeeded()
            viewControllers[safe: page + 1]?.fetchIfNeeded()
            
            controller.currentPage = page
        }
    }
}
