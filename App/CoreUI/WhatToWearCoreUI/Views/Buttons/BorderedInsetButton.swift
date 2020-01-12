import Foundation

public final class BorderedInsetButton: InsetButton {
    // MARK: init
    public init(
        insets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10),
        onTap: @escaping () -> Void
    ) {
        super.init(
            color: .clear,
            insets: insets,
            onTap: onTap
        )

        self.label.textColor = .white

        BorderConfigurator.configureBorder(for: self)
    }
}
