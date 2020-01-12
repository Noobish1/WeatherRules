import UIKit

public class InsetButton: CodeBackedControl {
    // MARK: overrides
    public override var isHighlighted: Bool {
        didSet {
            if bgColor == .clear {
                backgroundColor = isHighlighted ? Colors.selectedBackground : bgColor
            } else {
                backgroundColor = isHighlighted ? bgColor.darker(by: 20.percent) : bgColor
            }
        }
    }

    // MARK: properties
    private let insets: UIEdgeInsets
    private let onTap: () -> Void
    public let label = UILabel().then {
        $0.textAlignment = .center
    }
    public var bgColor: UIColor {
        didSet {
            backgroundColor = bgColor
        }
    }

    // MARK: init
    public init(
        color: UIColor,
        insets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10),
        onTap: @escaping () -> Void
    ) {
        self.insets = insets
        self.bgColor = color
        self.onTap = onTap

        super.init(frame: .zero)

        //self.bgColor = color does not call the didSet
        self.backgroundColor = color
        self.accessibilityTraits = .button
        self.addTarget(self, action: #selector(selfTapped), for: .touchUpInside)

        setupViews()
    }

    // MARK: setup
    private func setupViews() {
        add(subview: label, withConstraints: { make in
            make.edges.equalToSuperview().inset(insets)
        })
    }

    // MARK: interface actions
    @objc
    private func selfTapped() {
        onTap()
    }
}
