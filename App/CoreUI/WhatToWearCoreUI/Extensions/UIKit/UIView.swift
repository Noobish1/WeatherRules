import SnapKit
import UIKit

// MARK: calculations
extension UIView {
    public func heightForConstrainedWidth(_ width: CGFloat) -> CGFloat {
        let size = self.systemLayoutSizeFitting(
            CGSize(width: width, height: 9999),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        )

        return ceil(size.height)
    }
}

// MARK: General extensions
extension UIView {
    // MARK: fullscreen views
    public func add(fullscreenSubview: UIView) {
        add(subview: fullscreenSubview, withConstraints: { make in
            make.edges.equalToSuperview()
        })
    }

    // MARK: separator views
    public func add(leftSeparatorView: UIView, onTheRightOf safeAreaLayoutGuide: UILayoutGuide? = nil) {
        add(separatorView: leftSeparatorView, toSide: .leading, of: safeAreaLayoutGuide)
    }

    public func add(rightSeparatorView: UIView, onTheLeftOf safeAreaLayoutGuide: UILayoutGuide? = nil) {
        add(separatorView: rightSeparatorView, toSide: .trailing, of: safeAreaLayoutGuide)
    }

    public func add(topSeparatorView: UIView, beneath otherView: UIView, offset: CGFloat = 0) {
        add(topSeparatorView: topSeparatorView, beneath: otherView.snp.bottom, offset: offset)
    }

    public func add(topSeparatorView: UIView, beneath otherItem: ConstraintItem? = nil, offset: CGFloat = 0) {
        add(subview: topSeparatorView, withConstraints: { make in
            if let otherView = otherItem {
                make.top.equalTo(otherView).offset(offset)
            } else {
                make.top.equalToSuperview().offset(offset)
            }

            make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
            make.height.equalTo(1)
        })
    }

    public func add(separatorView: UIView, above view: UIView) {
        add(subview: separatorView, withConstraints: { make in
            make.leading.equalToSuperviewOrSafeAreaLayoutGuide()
            make.trailing.equalToSuperviewOrSafeAreaLayoutGuide()
            make.bottom.equalTo(view.snp.top)
            make.height.equalTo(1)
        })
    }
    
    private func add(
        separatorView: UIView,
        toSide side: ConstraintMaker.Side,
        of safeAreaLayoutGuide: UILayoutGuide? = nil
    ) {
        add(subview: separatorView, withConstraints: { make in
            make.top.equalToSuperview()
            
            if let safeAreaLayoutGuide = safeAreaLayoutGuide {
                make.mv_constraint(for: side).equalTo(safeAreaLayoutGuide).offset(side.backgroundOffset)
            } else {
                make.mv_constraint(for: side).equalToSuperview().offset(side.backgroundOffset)
            }
            
            make.width.equalTo(1)
            make.bottom.equalToSuperview()
        })
    }

    // MARK: adding subviews
    public func add(subviews: [UIView], withConstraints constraints: (ConstraintMaker) -> Void) {
        subviews.forEach {
            add(subview: $0, withConstraints: constraints)
        }
    }

    public func add(subview: UIView, withConstraints constraints: (ConstraintMaker) -> Void) {
        addSubview(subview)

        subview.snp.remakeConstraints(constraints)
    }

    public func add(subview: UIView, withConstraints constraints: (ConstraintMaker) -> Void, subviews: (UIView) -> Void) {
        addSubview(subview)

        subview.snp.remakeConstraints(constraints)

        subviews(subview)
    }

    public func insertSubview(_ subview: UIView, at index: Int, withConstraints constraints: (ConstraintMaker) -> Void) {
        insertSubview(subview, at: index)

        subview.snp.remakeConstraints(constraints)
    }

    // MARK: subviews
    public func subviews<T: UIView>(ofType type: T.Type) -> [T] {
        var matchingSubviews: [T] = []

        for subview in subviews {
            if let matchingSubview = subview as? T {
                matchingSubviews.append(matchingSubview)
            }

            let subMatchingSubviews = subview.subviews(ofType: type)

            matchingSubviews.append(contentsOf: subMatchingSubviews)
        }

        return matchingSubviews
    }

    public func firstSubview<T: UIView>(ofType type: T.Type) -> T? {
        for subview in subviews {
            if let matchingSubview = subview as? T {
                return matchingSubview
            }

            if let matchingSubview = subview.firstSubview(ofType: type) {
                return matchingSubview
            }
        }

        return nil
    }
}
