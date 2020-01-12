import UIKit

public final class BorderedButton: CustomButton {
    // MARK: init
    public convenience init() {
        self.init(color: .clear)

        self.tintColor = .white

        BorderConfigurator.configureBorder(for: self)

        setTitleColor(.white, for: .normal)
    }
}
