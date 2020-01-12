import UIKit
import WhatToWearCore
import WhatToWearCoreUI
import WhatToWearModels

internal final class SegmentedControl<T: FiniteSetViewModelProtocol>: CodeBackedView {
    // MARK: State
    internal typealias State = T

    // MARK: properties
    private let containerView = UIView()
    private let allStates = State.nonEmptySet
    private var state: State
    private let buttons: [SegmentedButton]
    private let onSegmentChange: (State) -> Void
    private let constraintMaker = StackConstraintMaker(
        direction: .horizontal,
        distribution: .equally
    )

    // MARK: init
    internal init(
        initialValue: State,
        onSegmentChange: @escaping (State) -> Void
    ) {
        let mainColor = Colors.blueButton.darker(by: 10.percent)
        
        self.state = initialValue
        self.onSegmentChange = onSegmentChange
        self.buttons = allStates.map { value in
            SegmentedButton(bgColor: mainColor).then {
                $0.setTitle(value.shortTitle, for: .normal)
            }
        }

        super.init(frame: .zero)

        setupViews(mainColor: mainColor)
        select(segment: initialValue)
    }

    // MARK: setup
    private func setupLayer(mainColor: UIColor) {
        layer.borderWidth = 1
        layer.borderColor = mainColor.cgColor
    }

    private func setupButtons() {
        buttons.forEach {
            $0.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        }
    }

    private func setupViews(mainColor: UIColor) {
        setupLayer(mainColor: mainColor)
        setupButtons()

        add(subview: containerView, withConstraints: { make in
            make.edges.equalToSuperview()
            make.height.equalTo(40)
        })

        constraintMaker.setupConstraints(forViews: buttons, in: containerView)
    }

    // MARK: programmatic selection
    internal func select(segment: State) {
        guard let index = allStates.firstIndex(of: segment) else {
            fatalError("We should never have \(State.self) value that isn't in it's nonEmptyCases array")
        }

        selectSegment(at: index)
    }

    private func selectSegment(at index: Int) {
        buttons.forEach { $0.isSelected = false }

        buttons[index].isSelected = true

        self.state = allStates[index]
    }

    // MARK: interface actions
    @objc
    private func buttonTapped(sender: SegmentedButton) {
        guard let buttonIndex = buttons.firstIndex(of: sender) else {
            fatalError("Somehow a button was tapped that isn't in the buttons array")
        }

        selectSegment(at: buttonIndex)

        onSegmentChange(state)
    }
}
