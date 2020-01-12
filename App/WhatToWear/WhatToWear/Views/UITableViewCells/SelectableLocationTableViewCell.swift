import SnapKit
import UIKit
import WhatToWearAssets
import WhatToWearCoreUI
import WhatToWearModels

internal final class SelectableLocationTableViewCell: CodeBackedCell {
    // MARK: SelectionState
    private enum SelectionState {
        case selected
        case unSelected
        
        // MARK: computed property
        fileprivate var image: UIImage? {
            switch self {
                case .selected: return R.image.selectedRule()
                case .unSelected: return R.image.unselectedRule()
            }
        }
        
        fileprivate var rightViewZeroWidthConstraintPriority: ConstraintPriority {
            switch self {
                case .selected: return .low
                case .unSelected: return .almostRequired
            }
        }
        
        fileprivate var backgroundColor: UIColor {
            switch self {
                case .selected: return Colors.selectedBackground
                case .unSelected: return UIColor.clear
            }
        }
        
        // MARK: init
        fileprivate init(selected: Bool) {
            self = selected ? .selected : .unSelected
        }
    }
    
    // MARK: properties
    private let nameLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .boldSystemFont(ofSize: 15)
        $0.numberOfLines = 0
    }
    private let selectionImageView = UIImageView(image: R.image.unselectedRule()).then {
        $0.tintColor = .white
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }
    private let bottomSeparatorView = SeparatorView()
    private let leftView = UIView()
    private let rightView = UIView().then {
        $0.clipsToBounds = true
    }
    // swiftlint:disable implicitly_unwrapped_optional
    private var rightViewZeroWidthConstraint: Constraint!
    // swiftlint:enable implicitly_unwrapped_optional
    
    // MARK: setup
    internal override func setupViews() {
        super.setupViews()

        backgroundColor = .clear
        selectedBackgroundView = DefaultSelectedBackgroundView()
        
        contentView.add(
            subview: leftView,
            withConstraints: { make in
                make.top.equalToSuperview().offset(20)
                make.leading.equalToSuperview().offset(10)
            },
            subviews: { container in
                container.add(subview: nameLabel, withConstraints: { make in
                    make.top.equalToSuperview()
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                    make.bottom.equalToSuperview()
                })
            }
        )

        contentView.add(
            subview: rightView,
            withConstraints: { make in
                make.top.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().inset(10)
                make.leading.equalTo(leftView.snp.trailing).offset(10)
                rightViewZeroWidthConstraint = make.width.equalTo(0).priority(.almostRequired).constraint
            },
            subviews: { container in
                container.add(subview: selectionImageView, withConstraints: { make in
                    make.top.equalToSuperview()
                    make.leading.equalToSuperview().priority(.high)
                    make.trailing.equalToSuperview()
                    make.bottom.equalToSuperview()
                    make.size.equalTo(30)
                })
            }
        )

        contentView.add(subview: bottomSeparatorView, withConstraints: { make in
            make.top.equalTo(leftView.snp.bottom).offset(20)
            make.top.equalTo(rightView.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        })
    }

    // MARK: reuse
    internal override func prepareForReuse() {
        super.prepareForReuse()

        selectionImageView.image = R.image.unselectedRule()
    }

    // MARK: selection
    internal override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        bottomSeparatorView.backgroundColor = Colors.separator
    }
    
    internal override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        bottomSeparatorView.backgroundColor = Colors.separator
    }
    
    // MARK: configuration
    internal func configure(with validLocation: ValidLocation, selected: Bool) {
        nameLabel.text = validLocation.address
        
        let state = SelectionState(selected: selected)
        
        selectionImageView.image = state.image
        rightViewZeroWidthConstraint.update(priority: state.rightViewZeroWidthConstraintPriority)
        backgroundColor = state.backgroundColor
    }
}
