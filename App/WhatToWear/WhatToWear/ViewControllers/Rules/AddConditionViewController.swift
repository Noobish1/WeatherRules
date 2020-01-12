import ErrorRecorder
import SnapKit
import Then
import UIKit
import WhatToWearCore
import WhatToWearCoreComponents
import WhatToWearCoreUI
import WhatToWearModels

internal final class AddConditionViewController: CodeBackedViewController, SelectionRequesterProtocol, TimeSelectionRequesterProtocol, NavStackEmbedded, Accessible {
    // MARK: state
    internal typealias State = AddConditionViewControllerState

    // MARK: layout
    internal enum Layout {
        case small
        case large

        // MARK: init
        internal init(width: CGFloat) {
            if width > 320 {
                self = .large
            } else {
                self = .small
            }
        }

        // MARK: computed properties
        internal var valueFont: UIFont {
            switch self {
                case .small: return UIFont.systemFont(ofSize: 14)
                case .large: return UIFont.systemFont(ofSize: 17)
            }
        }

        internal var outerXPadding: CGFloat {
            switch self {
                case .small: return 10
                case .large: return 20
            }
        }
    }

    // MARK: AccessibilityIdentifiers
    internal enum AccessibilityIdentifiers: String, AccessibilityIdentifiersProtocol {
        internal typealias EnclosingType = AddConditionViewController

        case contentView = "contentView"
    }

    // MARK: properties
    private let backgroundView = BasicBackgroundView()
    private lazy var contentView = AddConditionContentView(
        state: state,
        layout: layout,
        onAdd: { [weak self] in
            self?.addButtonTapped()
        }
    ).then {
        $0.wtw_setAccessibilityIdentifier(AccessibilityIdentifiers.contentView)
        $0.measurementButton.addTarget(self, action: #selector(measurementButtonTapped), for: .touchUpInside)
        $0.clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
    }
    private let onDone: (Condition) -> Void
    private let measurementSystem: MeasurementSystem
    private let layout = Layout(width: UIScreen.main.bounds.width)
    private var state: State

    internal let timeInputTransitioner = BottomAnchoredTransitioner()

    // MARK: init/deinit
    internal init(state: State = .empty, onDone: @escaping (Condition) -> Void) {
        self.state = state
        self.measurementSystem = GlobalSettingsController.shared.retrieve().measurementSystem
        self.onDone = onDone

        super.init()

        self.title = state.viewControllerTitle
    }

    // MARK: setup
    private func setupViews() {
        view.backgroundColor = .white

        view.add(fullscreenSubview: backgroundView)

        view.add(subview: contentView, withConstraints: { make in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        })
    }

    // MARK: UIViewController
    internal override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupNavigation()

        transition(to: state, force: true)
    }

    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Analytics.record(screen: .addCondition)
    }

    // MARK: prompting
    private func promptUserForTimeSymbolSelection(
        for measurement: TimeMeasurement,
        initialSymbol: TimeSymbol?
    ) {
        promptUserForSelection(
            title: NSLocalizedString("Select Symbol", comment: ""),
            initial: initialSymbol.map(TimeSymbolViewModel.init),
            then: { [weak self] returnedSymbol in
                // All Time measurements have a default value
                let condition = TimeCondition(
                    measurement: measurement,
                    symbol: returnedSymbol,
                    value: .allDay
                )

                self?.transition(to: .condition(.time(condition)))
            }
        )
    }

    private func promptUserForDoubleSymbolSelection(
        for measurement: DoubleMeasurement,
        initialSymbol: DoubleSymbol?
    ) {
        promptUserForSelection(
            title: NSLocalizedString("Select Symbol", comment: ""),
            initial: initialSymbol.map(DoubleSymbolViewModel.init),
            then: { [weak self] returnedSymbol in
                let pair = MeasurementSymbolPair.double(
                    measurement: measurement,
                    symbol: returnedSymbol
                )

                self?.transition(to: .measurementSymbol(pair))
            }
        )
    }

    @objc
    private func measurementButtonTapped() {
        let priorState = state

        let vc = MeasurementsViewController(
            system: measurementSystem,
            initial: priorState.measurement,
            onSelection: { [weak self] newMeasurement in
                if priorState.measurement != newMeasurement {
                    self?.transition(
                        to: State(afterSelectingMeasurement: newMeasurement)
                    )
                }

                self?.navController.popViewController(animated: true)
            }
        )

        navController.pushViewController(vc, animated: true)
    }

    @objc
    private func clearButtonTapped() {
        transition(to: .empty)
    }

    @objc
    private func addButtonTapped() {
        switch state {
            case .empty:
                contentView.measurementButton.transition(to: .highlightNoSelection)
            case .doubleMeasurement(let measurement):
                contentView.symbolButtonContainer.transition(to: .highlightedNoSelection(SymbolButton(
                    state: .highlightedNoSelection(measurement: .double(measurement)),
                    layout: layout,
                    onTap: { [weak self] _ in
                        self?.promptUserForDoubleSymbolSelection(
                            for: measurement,
                            initialSymbol: nil
                        )
                    }
                )))
            case .timeMeasurement(let measurement):
                contentView.symbolButtonContainer.transition(to: .highlightedNoSelection(SymbolButton(
                    state: .highlightedNoSelection(measurement: .time(measurement)),
                    layout: layout,
                    onTap: { [weak self] _ in
                        self?.promptUserForTimeSymbolSelection(
                            for: measurement,
                            initialSymbol: nil
                        )
                    }
                )))
            case .measurementSymbol:
                switch contentView.valueButtonContainer.state {
                    case .notVisible:
                        // Can't be wrong if it isn't visible
                        break
                    case .basicButton(let button):
                        button.transition(to: .highlightedNoSelection)
                    case .doubleButton(let button):
                        button.transition(to: .highlightedNoSelection)
                    case .timeRangeView:
                        // This one is always valid
                        break
                }
            case .condition(let condition):
                onDone(condition)
        }
    }

    // MARK: transition
    private func transition(to newState: State, force: Bool = false) {
        guard force || newState != state else { return }

        let measurementButtonState = newState.measurementButtonState(for: measurementSystem)

        contentView.measurementButton.transition(to: measurementButtonState)
        contentView.symbolButtonContainer.transition(to: symbolButtonContainerState(for: newState))
        contentView.valueButtonContainer.transition(to: valueButtonContainerState(for: newState))

        self.state = newState
    }

    // MARK: symbolButtonContainerStates
    private func symbolButtonContainerState(for newState: State) -> SymbolButtonContainerView.State {
        switch newState {
            case .empty:
                return .notVisible
            case .doubleMeasurement(let doubleMeasurement):
                return .noSelection(SymbolButton(
                    state: .noSelection(measurement: .double(doubleMeasurement)),
                    layout: layout,
                    onTap: { [weak self] _ in
                        self?.promptUserForDoubleSymbolSelection(
                            for: doubleMeasurement, initialSymbol: nil
                        )
                    }))
            case .timeMeasurement(let timeMeasurement):
                return .noSelection(SymbolButton(
                    state: .noSelection(measurement: .time(timeMeasurement)),
                    layout: layout,
                    onTap: { [weak self] _ in
                        self?.promptUserForTimeSymbolSelection(
                            for: timeMeasurement, initialSymbol: nil
                        )
                    }))
            case .measurementSymbol(let pair):
                return symbolButtonContainerState(forPair: pair)
            case .condition(let condition):
                return symbolButtonContainerState(forCondition: condition)
        }
    }

    private func symbolButtonContainerState(
        forPair pair: MeasurementSymbolPair
    ) -> SymbolButtonContainerView.State {
        switch pair {
            case .double(measurement: let doubleMeasurement, symbol: let symbol):
                return .selected(SymbolButton(
                    state: .selected(pair: .double(measurement: doubleMeasurement, symbol: symbol)),
                    layout: layout,
                    onTap: { [weak self] _ in
                        self?.promptUserForDoubleSymbolSelection(
                            for: doubleMeasurement, initialSymbol: symbol
                        )
                    }
                ))
            case .enumeration(measurement: _, symbol: let symbol):
                let title = SelectableMeasurementSymbolViewModel.longTitle(for: symbol)
                
                return .selectedAndDisabled(title: title)
            case .time(measurement: let timeMeasurement, symbol: let symbol):
                return .selected(SymbolButton(
                    state: .selected(pair: .time(measurement: timeMeasurement, symbol: symbol)),
                    layout: layout,
                    onTap: { [weak self] _ in
                        self?.promptUserForTimeSymbolSelection(
                            for: timeMeasurement, initialSymbol: symbol
                        )
                    }
                ))
        }
    }

    private func symbolButtonContainerState(forCondition condition: Condition) -> SymbolButtonContainerView.State {
        switch condition {
            case .double(let doubleCondition):
                return .selected(SymbolButton(
                    state: .selected(
                        pair: .double(
                            measurement: doubleCondition.measurement, symbol: doubleCondition.symbol
                        )
                    ),
                    layout: layout,
                    onTap: { [weak self] _ in
                        self?.promptUserForSelection(
                            title: NSLocalizedString("Select Symbol", comment: ""),
                            initial: DoubleSymbolViewModel(model: doubleCondition.symbol),
                            then: { [weak self] returnedSymbol in
                                let condition = doubleCondition.with(\.symbol, value: returnedSymbol)

                                self?.transition(to: .condition(.double(condition)))
                            }
                        )
                    }
                ))
            case .time(let timeCondition):
                return .selected(SymbolButton(
                    state: .selected(pair: .time(measurement: timeCondition.measurement, symbol: timeCondition.symbol)),
                    layout: layout,
                    onTap: { [weak self] _ in
                        self?.promptUserForSelection(
                            title: NSLocalizedString("Select Symbol", comment: ""),
                            initial: TimeSymbolViewModel(model: timeCondition.symbol),
                            then: { [weak self] returnedSymbol in
                                let condition = timeCondition.with(\.symbol, value: returnedSymbol)

                                self?.transition(to: .condition(.time(condition)))
                            }
                        )
                    }
                ))
            case .enumeration(let enumCondition):
                let title = EnumConditionViewModel.title(for: enumCondition)
                
                return .selectedAndDisabled(title: title)
        }
    }

    // MARK: ValueButtonContainer states
    private func valueButtonContainerState(for newState: State) -> ValueButtonContainerView.State {
        switch newState {
            case .empty, .doubleMeasurement, .timeMeasurement:
                return .notVisible
            case .measurementSymbol(let pair):
                return valueButtonContainerState(for: ConditionTrio(pair: pair))
            case .condition(let condition):
                return valueButtonContainerState(for: ConditionTrio(condition: condition))
        }
    }

    private func valueButtonContainerState(
        for trio: ConditionTrio
    ) -> ValueButtonContainerView.State {
        switch trio {
            case .double(measurement: let doubleMeasurement, symbol: let symbol, value: let value):
                return .doubleButton(
                    doubleInputButton(for: doubleMeasurement, symbol: symbol, oldValue: value)
                )
            case .time(measurement: let timeMeasurement, symbol: let symbol, value: let value):
                return valueButtonContainerState(
                    measurement: timeMeasurement,
                    symbol: symbol,
                    value: value
                )
            case .enumeration(let enumTrio):
                return .basicButton(selectableButton(trio: enumTrio))
        }
    }

    private func valueButtonContainerState(
        measurement: TimeMeasurement,
        symbol: TimeSymbol,
        value: TimeRange?
    ) -> ValueButtonContainerView.State {
        let oldValue = value ?? .allDay

        switch symbol {
            case .between:
                return .timeRangeView(timeRangeView(
                    for: measurement,
                    symbol: symbol,
                    oldValue: oldValue
                ))
            case .before:
                return .basicButton(timeButton(
                    for: measurement,
                    symbol: symbol,
                    timeRange: oldValue,
                    initialTime: { $0.end },
                    updateTimeRange: { $0.with(end: $1, validate: true) }
                ))
            case .after:
                return .basicButton(timeButton(
                    for: measurement,
                    symbol: symbol,
                    timeRange: oldValue,
                    initialTime: { $0.start },
                    updateTimeRange: { $0.with(start: $1, validate: true) }
                ))
        }
    }

    // MARK: creating double input buttons
    private func doubleInputButton(
        for measurement: DoubleMeasurement,
        symbol: DoubleSymbol,
        oldValue: Double?
    ) -> DoubleInputButton {
        return DoubleInputButton(
            rawValue: oldValue,
            measurement: measurement,
            system: measurementSystem,
            layout: layout,
            onDone: { [weak self] newDisplayedValue in
                let newCondition = DoubleCondition(
                    measurement: measurement,
                    symbol: symbol,
                    value: measurement.rawValue(forDisplayedValue: newDisplayedValue)
                )

                self?.transition(to: .condition(.double(newCondition)))
            }
        )
    }

    // MARK: creating basic value buttons
    private func timeButton(
        for measurement: TimeMeasurement,
        symbol: TimeSymbol,
        timeRange: TimeRange,
        initialTime initialTimeClosure: (TimeRange) -> MilitaryTime,
        updateTimeRange: @escaping (TimeRange, MilitaryTime) -> TimeRange
    ) -> BasicValueButton {
        let initialTime = initialTimeClosure(timeRange)
        let title = MilitaryTimeViewModel.displayedString(for: initialTime, timeZone: .current)

        return BasicValueButton(title: title, layout: layout, onTap: { [weak self] _ in
            self?.promptUserForTime(initialTime: initialTime, onDone: { time in
                let newTimeRange = updateTimeRange(timeRange, time)
                let newCondition = TimeCondition(
                    measurement: measurement, symbol: symbol, value: newTimeRange
                )

                self?.transition(to: .condition(.time(newCondition)))
            })
        })
    }

    private func selectableButton(trio: EnumConditionTrio) -> BasicValueButton {
        switch trio {
            case .precipType(measurement: let precipMeasurement, symbol: _, value: let value):
                let valueVM = value.map(PrecipitationTypeViewModel.init)
                
                return selectableButton(for: precipMeasurement, oldValueViewModel: valueVM, conditionCreation: { newValue in
                    .enumeration(.precipType(SelectableCondition(measurement: precipMeasurement, value: newValue)))
                })
            case .windDirection(measurement: let windMeasurement, symbol: _, value: let value):
                let valueVM = value.map(WindDirectionViewModel.init)
                
                return selectableButton(for: windMeasurement, oldValueViewModel: valueVM, conditionCreation: { newValue in
                    .enumeration(.windDirection(SelectableCondition(measurement: windMeasurement, value: newValue)))
                })
            case .dayOfWeek(measurement: let dayOfWeekMeasurement, symbol: _, value: let value):
                let valueVM = value.map(DayOfWeekViewModel.init)
                
                return selectableButton(for: dayOfWeekMeasurement, oldValueViewModel: valueVM, conditionCreation: { newValue in
                    .enumeration(.dayOfWeek(SelectableCondition(measurement: dayOfWeekMeasurement, value: newValue)))
                })
        }
    }

    private func selectableButton<Value, ValueViewModel: ShortLongFiniteSetViewModelProtocol>(
        for measurement: SelectableMeasurement<Value>,
        oldValueViewModel: ValueViewModel?,
        conditionCreation: @escaping (ValueViewModel.UnderlyingModel) -> Condition
    ) -> BasicValueButton {
        return BasicValueButton(
            title: oldValueViewModel?.shortTitle,
            layout: layout,
            onTap: { [weak self] _ in
                self?.promptUserForSelection(
                    title: NSLocalizedString("Select Value", comment: ""),
                    initial: oldValueViewModel,
                    then: { (newValue: ValueViewModel.UnderlyingModel) in
                        let newCondition = conditionCreation(newValue)

                        self?.transition(to: .condition(newCondition))
                    })
            }
        )
    }

    // MARK: creating time range views
    private func timeRangeView(
        for measurement: TimeMeasurement,
        symbol: TimeSymbol,
        oldValue: TimeRange
    ) -> TimeRangeView {
        return timeRangeView(for: oldValue, onChange: { [weak self] timeRange in
            let newCondition = TimeCondition(
                measurement: measurement, symbol: symbol, value: timeRange
            )

            self?.transition(to: .condition(.time(newCondition)))
        })
    }

    private func timeRangeView(
        for initialTimeRange: TimeRange,
        onChange: @escaping (TimeRange) -> Void
    ) -> TimeRangeView {
        return TimeRangeView(
            timeRange: initialTimeRange,
            onFromTap: { [weak self] _, currentTimeRange in
                self?.promptUserForTime(initialTime: currentTimeRange.start, onDone: { time in
                    let newTimeRange = currentTimeRange.with(start: time, validate: true)

                    onChange(newTimeRange)
                })
            },
            onUntilTap: { [weak self] _, currentTimeRange in
                self?.promptUserForTime(initialTime: currentTimeRange.end, onDone: { time in
                    let newTimeRange = currentTimeRange.with(end: time, validate: true)

                    onChange(newTimeRange)
                })
            }
        )
    }

    // MARK: inset updates
    internal override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11, *) {
            contentView.update(bottomInset: view.safeAreaInsets.bottom)
        }
    }
}
