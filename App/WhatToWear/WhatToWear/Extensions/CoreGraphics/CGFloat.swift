import CoreGraphics

extension CGFloat {
    // MARK: tableview section header heights
    internal static var tableViewZeroHeaderHeight: CGFloat {
        if #available(iOS 11, *) {
            return .leastNormalMagnitude
        } else {
            return 1.1
        }
    }
}
