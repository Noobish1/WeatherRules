import UIKit

public final class SeparatorView: UIView {
    // MARK: init
    public convenience init() {
        self.init(frame: .zero)

        self.backgroundColor = Colors.separator
    }
}
