import SnapKit
import Then
import UIKit

internal final class StackConstraintMaker: Then {
    // MARK: Direction
    internal enum Direction {
        case horizontal
        case vertical
    }

    // MARK: Distribution
    internal enum Distribution {
        case equally
        case proportionally
    }

    // MARK: properties
    private let direction: Direction
    private let distribution: Distribution

    // MARK: init
    internal init(direction: Direction, distribution: Distribution) {
        self.direction = direction
        self.distribution = distribution
    }

    // MARK: constraints
    internal func setupConstraints(forViews views: [UIView], in containerView: UIView) {
        views.enumerated().forEach { index, view in
            containerView.add(subview: view, withConstraints: constraints(
                at: index,
                in: views,
                containerView: containerView
            ))
        }
    }

    // swiftlint:disable cyclomatic_complexity
    internal func constraints(at index: Int, in views: [UIView], containerView: UIView) -> ((ConstraintMaker) -> Void) {
        return { make in
            switch self.direction {
                case .horizontal:
                    make.top.equalToSuperview()
                    make.bottom.equalToSuperview()
                case .vertical:
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
            }

            if index == 0 {
                switch self.direction {
                    case .horizontal: make.leading.equalToSuperview()
                    case .vertical: make.top.equalToSuperview()
                }
            } else {
                let previousView = views[index - 1]

                switch self.direction {
                    case .horizontal:
                        make.leading.equalTo(previousView.snp.trailing)
                    case .vertical:
                        make.top.equalTo(previousView.snp.bottom)
                }

                switch (self.direction, self.distribution) {
                    case (.horizontal, .equally):
                        make.width.equalTo(previousView)
                    case (.vertical, .equally):
                        make.height.equalTo(previousView)
                    case (.horizontal, .proportionally), (.vertical, .proportionally):
                        break
                }
            }

            if index == (views.endIndex - 1) {
                switch self.direction {
                    case .horizontal: make.trailing.equalToSuperview()
                    case .vertical: make.bottom.equalToSuperview()
                }
            }
        }
    }
    // swiftlint:enable cyclomatic_complexity
}
