import WhatToWearCore
import WhatToWearCoreUI

internal final class SegmentedControlCell<VM: FiniteSetViewModelProtocol>: CodeBackedCell {
    // MARK: properties
    private let insets = UIEdgeInsets(top: 14, left: 20, bottom: 14, right: 20)
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
    }
    private lazy var control = SegmentedControl(
        initialValue: VM.nonEmptySet.first,
        onSegmentChange: { [weak self] newValue in
            self?.onSegmentChange?(newValue)
        }
    )
    private let bottomSeparator = SeparatorView()
    private var onSegmentChange: ((VM) -> Void)?

    // MARK: setup
    internal override func setupViews() {
        super.setupViews()

        backgroundColor = .clear

        contentView.add(subview: titleLabel, withConstraints: { make in
            make.top.equalToSuperview().offset(insets.top)
            make.leading.equalToSuperview().offset(insets.left)
            make.trailing.equalToSuperview().inset(insets.right)
        })

        contentView.add(subview: control, withConstraints: { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(insets.left)
            make.trailing.equalToSuperview().inset(insets.right)
            make.bottom.equalToSuperview().inset(insets.bottom + 1)
        })

        contentView.add(subview: bottomSeparator, withConstraints: { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        })
    }

    // MARK: configuration
    internal func configure(
        title: String,
        selectedValue: VM,
        onSegmentChange: @escaping (VM) -> Void
    ) {
        titleLabel.text = title
        control.select(segment: selectedValue)
        self.onSegmentChange = onSegmentChange
    }
}
