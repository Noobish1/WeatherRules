import SnapKit
import Then
import UIKit

internal final class PagingConstraintMaker: Then {
    // MARK: PagingDirection
    internal enum PagingDirection {
        case horizontal
        case vertical
    }

    // MARK: properties
    private let pagingDirection: PagingDirection

    // MARK: init
    internal init(pagingDirection: PagingDirection = .horizontal) {
        self.pagingDirection = pagingDirection
    }

    // MARK: constraints
    internal func constraints(at index: Int, in views: [UIView], containerView: UIView) -> ((ConstraintMaker) -> Void) {
        // This is slow to type-check without the -> Void
        return { (make: ConstraintMaker) -> Void in
            make.width.equalTo(containerView)
            make.height.equalTo(containerView)

            switch self.pagingDirection {
                case .horizontal:
                    make.top.equalToSuperview()
                    make.bottom.equalToSuperview()
                case .vertical:
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
            }

            if index == 0 {
                switch self.pagingDirection {
                    case .horizontal: make.leading.equalToSuperview()
                    case .vertical: make.top.equalToSuperview()
                }
            } else {
                switch self.pagingDirection {
                    case .horizontal: make.leading.equalTo(views[index - 1].snp.trailing)
                    case .vertical: make.top.equalTo(views[index - 1].snp.bottom)
                }
            }

            if index == (views.endIndex - 1) {
                switch self.pagingDirection {
                    case .horizontal: make.trailing.equalToSuperview()
                    case .vertical: make.bottom.equalToSuperview()
                }
            }
        }
    }
}
