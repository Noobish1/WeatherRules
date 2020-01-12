import UIKit

// MARK: general
extension UITableView {
    // MARK: header/footer views
    public func layoutHeaderAndFooterViews() {
        if let header = self.tableHeaderView {
            layoutHeaderOrFooterView(header)
            self.tableHeaderView = header
        }

        if let footer = self.tableFooterView {
            layoutHeaderOrFooterView(footer)
            self.tableFooterView = footer
        }
    }

    public func layoutHeaderOrFooterView(_ view: UIView) {
        view.setNeedsLayout()
        view.layoutIfNeeded()

        let width = self.frame.width

        let size = view.systemLayoutSizeFitting(CGSize(width: width, height: 9999),
                                                withHorizontalFittingPriority: .required,
                                                verticalFittingPriority: .defaultLow)

        let height = ceil(size.height)
        var frame = view.frame
        frame.size.height = height
        frame.size.width = width
        view.frame = frame
    }

    public func wtw_dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(identifier: String) -> T {
        guard let header = dequeueReusableHeaderFooterView(withIdentifier: identifier) else {
            fatalError("Could not dequeue section header view with identifier: \(identifier)")
        }

        guard let ourHeaderView = header as? T else {
            fatalError("dequeued a section headerview that was not a \(T.self)")
        }

        return ourHeaderView
    }

    // MARK: cells
    public func wtw_dequeueReusableCell<T: UITableViewCell>(identifier: String, indexPath: IndexPath) -> T {
        let baseCell = dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        guard let cell = baseCell as? T else {
            fatalError("Could not dequeue a cell of type \(T.self)")
        }

        return cell
    }
}
