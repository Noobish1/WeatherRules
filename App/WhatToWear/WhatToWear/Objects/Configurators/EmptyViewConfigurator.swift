import UIKit

internal enum EmptyViewConfigurator {
    // MARK: configuration
    internal static func configure(titleLabel: UILabel) {
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 26, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    internal static func configure(subtitle: UILabel) {
        subtitle.textColor = .white
        subtitle.font = .systemFont(ofSize: 18, weight: .semibold)
        subtitle.textAlignment = .center
        subtitle.numberOfLines = 0
    }
}
